//
//  JellyfinMusicService.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-26.
//

import Foundation
import JellyfinAPI
import Get
import SwiftUI
import AVFoundation
import MediaPlayer

class JellyfinMusicService: ObservableObject {
    static var shared: JellyfinMusicService! = JellyfinMusicService()
    
    private var client: JellyfinClient?
    private var quickConnect: QuickConnect?
    private var player: AVPlayer?
    private var baseUrl: String?
    
    @Published var quickConnectCode: String = ""
    @Published var quickConnectFailed: Bool = false
    @Published var isSignedIn: Bool = false
    @Published var tracks: [String: String] = [:] // ID: Name
    @Published var albums: [String: String] = [:]
    @Published var artists: [String: String] = [:]
    
    // Now playing variables
    @Published var isPlaying = false
    @Published var currentTime: Double = 0
    @Published var duration: Double = 0
    @Published var nowPlayingTrack: Track?
    @Published var nowPlayingImageId: String?
    @Published var nowPlayingBlurHash: String?
    @Published var queue = Queue(played: [], manuallyAdded: [], unplayed: [])
    
    private init() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("Failed to set AVAudioSession")
        }
    }
    
    func configureClient(url: String, token: String?) {
        guard let newUrl = URL(string: url) else {
            print("Invalid URL provided")
            return
        }
        
        baseUrl = url
        
        let configuration = JellyfinClient.Configuration(
            url: newUrl,
            client: "Foxy",
            deviceName: UIDevice.current.name,
            deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown",
            version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
        )
        
        if let token = token {
            client = JellyfinClient(configuration: configuration, accessToken: token)
            DispatchQueue.main.async {
                self.isSignedIn = true
            }
        } else {
            client = JellyfinClient(configuration: configuration)
        }
        
        SecureStorage.shared.save(key: "url", value: url)
    }
    
    static func initialize(url: String, token: String?) {
        shared.configureClient(url: url, token: token)
    }
    
    static func isTokenValid(url: String, token: String) async -> Bool {
        guard let url = URL(string: "\(url)/Users/Me") else {
            print("No url")
            return false
        }
        
        let tmpClient = await JellyfinClient(configuration: .init(url: url, client: "Foxy", deviceName: UIDevice.current.name, deviceID: UIDevice.current.identifierForVendor?.uuidString ?? "Unknown", version: Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"), accessToken: token)
        
        let request = Request(url: url, method: .get)
        do {
            _ = try await tmpClient.send(request)
            print("Valid")
            return true // Will only execute on HTTP 200
        } catch {
            SecureStorage.shared.delete(key: "token")
            SecureStorage.shared.delete(key: "url")
            print(error.localizedDescription)
            return false
        }
    }
    
    // Function to try and sign in using a stored access token if one exists
    static func trySignIn() async -> Bool {
        guard let token = SecureStorage.shared.retrieve(key: "token"),
              let url = SecureStorage.shared.retrieve(key: "url") else {
            return false
        }
        
        var result: Bool = false
        
        result = await isTokenValid(url: url, token: token)
        
        guard result else {
            print("Token was invalid")
            return false
        }
        
        initialize(url: url, token: token)
        return true
    }

    
    @MainActor
    func setupQuickConnect() {
        quickConnect = QuickConnect(client: client!)
        
        Task {
            for await state in quickConnect!.$state.values {
                switch state {
                case .polling(let code):
                    quickConnectCode = code
                    quickConnectFailed = false
                case .authenticated(let secret):
                    SecureStorage.shared.save(key: "token", value: secret)
                    isSignedIn = true
                    quickConnectCode = ""
                case .error(_):
                    quickConnectCode = ""
                    quickConnectFailed = true
                default:
                    break
                }
            }
        }
    }
    
    @MainActor
    func startQuickConnect() {
        quickConnect!.start()
    }
    
    @MainActor
    func stopQuickConnect() {
        quickConnect!.stop()
    }
    
    func signInUsingCreditentials(username: String, password: String) async -> (Bool, String?) {
        do {
            let response = try await client!.signIn(username: username, password: password)
            SecureStorage.shared.save(key: "token", value: response.accessToken!)
            DispatchQueue.main.async {
                self.isSignedIn = true
                self.quickConnect!.stop()
            }
            return (true, nil)
        } catch {
            return (false, error.localizedDescription)
        }
    }
    
    func getTracksForAlbum(albumId: String, forSync: Bool) async -> [Track]? {
        if !forSync {
            if let album = SyncService.shared.getAlbum(id: albumId) {
                return album.tracks
            }
        }
        
        let request = Request<BaseItemDtoQueryResult>(path: "Items/", method: .get, query: [("ParentId", "\(albumId)")])
        do {
            let result = try await client!.send(request)
            
            guard let items = result.value.items else { return nil }
            
            var tracks: [Track] = []
            
            for item in items {
                guard let id = item.id, let name = item.name, let artist = item.albumArtist, let artistId = item.artistItems?.first?.id, var duration = item.runTimeTicks, let albumId = item.albumID, let hasLyrics = item.hasLyrics else { continue }
                
                duration = duration/10_000_000
                
                let newTrack = Track(id: id, title: name, duration: duration, artist: artist, artistId: artistId, albumId: albumId, hasLyrics: hasLyrics, isDownloaded: false)
                tracks.append(newTrack)
            }
            
            return tracks
        } catch {
            return nil
        }
    }
    
    private func parseAlbums(items: [BaseItemDto], forSync: Bool) async -> [Album] {
        var albums : [Album] = []
        
        await withTaskGroup(of: Album?.self) { group in
            for item in items {
                group.addTask {
                    guard let id = item.id,
                          let name = item.name,
                          let albumArtist = item.albumArtist,
                          let artistId = item.albumArtists?.first?.id,
                          let year = item.productionYear,
                          let premiereDate = item.premiereDate else { return nil }
                    
                    guard let tracks = await self.getTracksForAlbum(albumId: id, forSync: forSync) else { return nil }
                    
                    var blurHash: String? = nil
                    if let imageTag = item.imageTags?["Primary"] {
                        blurHash = item.imageBlurHashes?.primary?[imageTag]
                    }
                    
                    let newAlbum = Album(id: id, title: name, imageBlurHash: blurHash, year: String(year), premiereDate: premiereDate, artist: albumArtist, artistId: artistId, tracks: tracks)
                    
                    return newAlbum
                }
            }
            
            for await album in group {
                if let album = album {
                    albums.append(album)
                }
            }
        }
                
        return albums
    }
    
    private func requestAlbums(request: Request<BaseItemDtoQueryResult>, forSync: Bool) async -> [Album]? {
        do {
            let result = try await client!.send(request)
            
            guard let items = result.value.items else { return nil }
            
            print("Got items: \(items.count)")
                        
            return await parseAlbums(items: items, forSync: forSync)
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    private func getAlbumFromId(id: String) async -> Album? {
        if let album = SyncService.shared.getAlbum(id: id) {
            return album
        } else {
            let request = Request<BaseItemDto>(path: "/Items/\(id)", method: .get)
            
            do {
                let result = try await client!.send(request)
                
                let albums = await parseAlbums(items: [result.value], forSync: false)
                
                guard albums.count > 0 else { return nil }
                
                return albums[0]
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }
    
    func getAlbumsFromIds(ids: [String]) async -> [Album]? {
        var albums: [Album] = []
        
        await withTaskGroup(of: Album?.self) { group in
            for albumId in ids {
                group.addTask {
                    guard let album = await self.getAlbumFromId(id: albumId) else { return nil }
                    return album
                }
            }
            
            for await album in group {
                if let album = album {
                    albums.append(album)
                }
            }
        }
        
        return albums
    }
    
    func getRecentlyAdded(amount: Int?) async -> [Album]? {
        let request = Request<[BaseItemDto]>(path: "/Items/Latest", method: .get, query: [("includeItemTypes", "MusicAlbum"), ("limit", amount?.description ?? "10")])
        
        do {
            let result = try await client!.send(request)
            
            return await parseAlbums(items: result.value, forSync: false)
            
        } catch {
            print(error.localizedDescription, "recently added")
            return nil
        }
    }
    
    func getRecentlyPlayed() async -> [Album]? { // TODO: Store locally and use that
        let request = Request<BaseItemDtoQueryResult>(path: "/Items", method: .get, query: [("includeItemTypes", "Audio"), ("Recursive", "true"), ("sortOrder", "Descending"), ("sortBy", "DatePlayed"), ("limit", "200")])
        
        var albumIds: Set<String> = []
        var albums: [Album] = []
        
        do {
            let result = try await client!.send(request)
            
            guard let items = result.value.items else { return nil }
            
            for item: BaseItemDto in items {
                guard let albumId = item.albumID else { continue }
                if albumIds.contains(albumId) { continue }
                
                albumIds.insert(albumId)
                
                if albumIds.count >= 6 { break }
            }
            
            guard albumIds.count >= 6 else { return nil }
            
            await withTaskGroup(of: Album?.self) { group in
                for id: String in albumIds {
                    group.addTask {
                        return await self.getAlbumFromId(id: id)
                    }
                }
                
                for await album in group {
                    guard let album else { continue }
                    albums.append(album)
                }
            }
            
            guard albums.count >= 6 else { return nil }
            return albums
            
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    func getFavoriteAlbums() async -> [Album]? { // TODO: Store locally and use that
        let request = Request<BaseItemDtoQueryResult>(path: "/Items", method: .get, query: [("filters", "IsFavoriteOrLikes"), ("Recursive", "true"), ("includeItemTypes", "MusicAlbum")])
        
        return await requestAlbums(request: request, forSync: false)
    }
    
    func getImage(id: String) async -> UIImage? {
        if let image = ImageCache.shared.getCachedImage(for: id) {
            return image
        } else {
            let request = Request(path: "/Items/\(id)/Images/Primary", method: .get, query: [("maxWidth", "512"), ("maxHeight", "512")])
            
            do {
                let response = try await client!.send(request)
                
                ImageCache.shared.cacheImage(UIImage(data: response.data)!, for: id)
                
                return UIImage(data: response.data)!
            } catch {
                print("Failed to get image for \(id)")
                return nil
            }
        }
    }
    
    func getAlbumsFromArtistId(id: String) async -> [Album]? {
         if let artist = ArtistCache.shared.getArtist(id) {
             let albumsIds = artist.albumIds
             
             guard let albums = await getAlbumsFromIds(ids: albumsIds) else { return nil }
             return albums
        }
        
        if let artist = SyncService.shared.getArtist(id: id) {
            ArtistCache.shared.cacheArtist(artist)
            let albumsIds = artist.albumIds
            
            guard let albums = await getAlbumsFromIds(ids: albumsIds) else { return nil }
            return albums
        }
        
        let request = Request<BaseItemDtoQueryResult>(path: "/Items", method: .get, query: [("parentId", id), ("includeItemTypes", "MusicAlbum")])
        
        return await requestAlbums(request: request, forSync: false)
    }
    
    @discardableResult
    func getArtistById(id: String) async -> Artist? {
        if let artist = ArtistCache.shared.getArtist(id) {
            return artist
        } else if let artist = SyncService.shared.getArtist(id: id) {
            ArtistCache.shared.cacheArtist(artist)
            return artist
        } else {
            let request = Request<BaseItemDto>(path: "/Items/\(id)", method: .get)
            
            do {
                let response = try await client!.send(request)
                let value = response.value
                
                guard let id = value.id, let name = value.name else { return nil }
                
                guard let albums: [Album] = await getAlbumsFromArtistId(id: id) else { return nil }
                
                let sortedAlbums = albums.sorted {$0.premiereDate > $1.premiereDate}
                let albumIds = sortedAlbums.map { $0.id }
                
                var blurHash: String? = nil
                if let imageTag = value.imageTags?["Primary"] {
                    blurHash = value.imageBlurHashes?.primary?[imageTag]
                }
                
                let artist = Artist(id: id, name: name, blurHash: blurHash, albumIds: albumIds)
                
                ArtistCache.shared.cacheArtist(artist)
                
                return artist
                
            } catch {
                print(error.localizedDescription)
                return nil
            }
        }
    }

    func cacheArtist(artistId: String) async {
        guard ArtistCache.shared.getArtist(artistId) == nil else { return }
        
        await getArtistById(id: artistId)
    }
    
    @MainActor
    func syncAllAlbums() async {
        let request = Request<BaseItemDtoQueryResult>(path: "/Items", method: .get, query: [("includeItemTypes", "MusicAlbum"), ("Recursive", "true")])
        
        guard let albums = await requestAlbums(request: request, forSync: true) else {
            print("Failed to get albums")
            return
        }
        
        for album in albums {
            self.albums[album.id] = album.title
            
            album.tracks.forEach { track in
                self.tracks[track.id] = track.title
            }
        }
        
        print(self.albums.count)
        print(self.tracks.count)
        
        SyncService.shared.saveAlbums(albums)
    }
    
    func getAlbumsForArtistBatch(artistIds: [String]) async -> [String: [String]?] {
        var albums: [String: [String]] = [:]
        
        await withTaskGroup(of: (String, [String]?).self) { group in
            for artistId in artistIds {
                group.addTask {
                    guard let artistAlbums = await self.getAlbumsFromArtistId(id: artistId) else { return (artistId, nil)}
                    var albumIds: [String] = []
                    
                    for album in artistAlbums {
                        albumIds.append(album.id)
                    }
                    
                    return (artistId, albumIds)
                }
            }
            
            for await (artistId, artistAlbums) in group {
                if let artistAlbums = artistAlbums {
                    albums[artistId] = artistAlbums
                }
            }
        }
        
        return albums
    }
    
    func syncAllArtists() async {
        let request = Request<BaseItemDtoQueryResult>(path: "/Items", method: .get, query: [("includeItemTypes", "MusicArtist"), ("Recursive", "true")])
        
        do {
            let response = try await client!.send(request)
            
            guard let items = response.value.items else { return }
            
            var artists: [Artist] = []
            var artistAlbums: [String: [String]] = [:]
            
            for batchStart in stride(from: 0, to: items.count, by: 50) {
                let batch = Array(items[batchStart..<min(batchStart + 50, items.count)])
                let artistIds = batch.compactMap { $0.id }
                
                let artistAlbumsTmp = await getAlbumsForArtistBatch(artistIds: artistIds)
                
                for (artistId, albums) in artistAlbumsTmp {
                    artistAlbums[artistId] = albums
                }
            }
            
            for item in items {
                guard let id = item.id, let name = item.name, let albums = artistAlbums[id] else { continue }
                
                var blurHash: String? = nil
                if let imageTag = item.imageTags?["Primary"] {
                    blurHash = item.imageBlurHashes?.primary?[imageTag]
                }
                                        
                artists.append(Artist(id: id, name: name, blurHash: blurHash, albumIds: albums))
            }
            
            SyncService.shared.saveArtists(artists)
            
        } catch {
            print(error.localizedDescription)
            return
        }
    }
    
    @MainActor
    func addTrackToQueue(track: Track, manual: Bool) {
        if manual {
            queue.manuallyAdded.append(track)
        } else {
            queue.unplayed.append(track)
        }
    }
    
    @MainActor
    func removeTrackFromQueue(pos: Int, manual: Bool) {
        if manual {
            queue.manuallyAdded.remove(at: pos)
        } else {
            queue.unplayed.remove(at: pos)
        }
    }
    
    @MainActor
    func addAlbumToQueue(album: Album, manual: Bool) {
        if manual {
            for track in album.tracks {
                queue.manuallyAdded.append(track)
            }
        } else {
            for track in album.tracks {
                queue.unplayed.append(track)
            }
        }
    }
    
    @MainActor
    func clearQueue() {
        queue.manuallyAdded.removeAll()
        queue.unplayed.removeAll()
        queue.played.removeAll()
    }
    
    @MainActor
    func shuffleQueue() {
        queue.unplayed.append(contentsOf: queue.manuallyAdded)
        queue.unplayed.shuffle()
    }
    
    @MainActor
    private func updateNowPlaying() {
        var nowPlayingInfo = MPNowPlayingInfoCenter.default().nowPlayingInfo ?? [String:Any]()
        
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = currentTime
        nowPlayingInfo[MPNowPlayingInfoPropertyPlaybackRate] = player?.rate
        nowPlayingInfo[MPMediaItemPropertyTitle] = queue.unplayed.first?.title
        
        
    }
    
    @MainActor
    func playNext() {
        if let nextTrack = queue.manuallyAdded.first {
            queue.unplayed.append(nextTrack)
            queue.manuallyAdded.removeFirst()
        } else if let nextTrack = queue.unplayed.first {
            queue.played.append(nextTrack)
            queue.unplayed.removeFirst()
        } else {
            return
        }
        
        play()
    }
    
    @MainActor
    func playPrevious() {
        if let previousTrack = queue.played.last {
            queue.unplayed.append(previousTrack)
            queue.played.removeLast()
        }
        
        play()
    }
    
    @MainActor
    func play() {
        guard queue.manuallyAdded.isEmpty || queue.unplayed.isEmpty else { print("Returning")
            return }
        var track: Track
        if queue.manuallyAdded.count > 0 {
            track = queue.manuallyAdded.removeFirst()
        } else {
            track = queue.unplayed.removeFirst()
        }
        
        isPlaying = true
        nowPlayingTrack = track
        nowPlayingImageId = track.albumId
        
        Task {
            print("Getting album info")
            if let album = await getAlbumFromId(id: track.albumId) {
                self.nowPlayingBlurHash = album.imageBlurHash
            } else {
                print("Failed to get album")
            }
        }
        
        player = AVPlayer(url: URL(string: "\(baseUrl!)/Audio/\(track.id)/universal?api_key=\(client!.accessToken!)&AudioCodec=aac&TranscodingProtocol=hls&Container=mp4|aac,alac,ac3,eac3,m4a|aac,alac,ac3,eac3,m4b|aac,alac,ac3,eac3,mp3|mp3,wav|pcm,alac,aiff|pcm,alac,flac|flac,mka|flac,aac,opus")!)
        player!.play()
    }
        
            
    func pause() {
        guard let player else { return }
        player.pause()
    }
    
    func resume() {
        guard let player else { return }
        player.play()
    }
}
