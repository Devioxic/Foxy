//
//  SyncService.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-10-04.
//

import Foundation

class SyncService {
    static let shared = SyncService()
    
    private let albumBatchSize = 100
    private let fileManager = FileManager.default
    private let albumsDirectory: URL
    private let artistsDirectory: URL
    private let miscDirectory: URL

    init() {
        // Set up directories
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        albumsDirectory = paths[0].appendingPathComponent("Albums")
        artistsDirectory = paths[0].appendingPathComponent("Artists")
        miscDirectory = paths[0].appendingPathComponent("Misc")
        
        // Create the directories if they don't exist
        if !fileManager.fileExists(atPath: albumsDirectory.path) {
            try? fileManager.createDirectory(at: albumsDirectory, withIntermediateDirectories: true)
        }
        if !fileManager.fileExists(atPath: artistsDirectory.path) {
            try? fileManager.createDirectory(at: artistsDirectory, withIntermediateDirectories: true)
        }
    }
    
    func saveAlbums(_ albums: [Album]) {
        var albumIndex: [String: String] = [:]
        let batches = albums.chunked(into: albumBatchSize)

        for (index, batch) in batches.enumerated() {
            let batchFileName = "albums_batch_\(index).json"
            let fileURL = albumsDirectory.appendingPathComponent(batchFileName)

            do {
                let data = try JSONEncoder().encode(batch)
                try data.write(to: fileURL)
                
                for album in batch {
                    albumIndex[album.id] = batchFileName
                }

                print("Album batch \(index + 1) saved successfully")
            } catch {
                print("Failed to save album batch \(index + 1): \(error.localizedDescription)")
            }
        }

        let indexFileURL = albumsDirectory.appendingPathComponent("albumIndex.json")
        do {
            let indexData = try JSONEncoder().encode(albumIndex)
            try indexData.write(to: indexFileURL)
            print("Album index saved successfully")
        } catch {
            print("Failed to save album index: \(error.localizedDescription)")
        }
    }



    func getAlbum(id: String) -> Album? {
        let indexFileURL = albumsDirectory.appendingPathComponent("albumIndex.json")
        guard let indexData = try? Data(contentsOf: indexFileURL),
              let albumIndex = try? JSONDecoder().decode([String: String].self, from: indexData) else {
            print("Failed to load album index or index not found")
            return nil
        }

        // Check if the album is in the index
        guard let batchFileName = albumIndex[id] else {
            print("Album not found in index")
            return nil
        }

        // Load the batch file containing the album
        let fileURL = albumsDirectory.appendingPathComponent(batchFileName)
        if let data = try? Data(contentsOf: fileURL),
           let albums = try? JSONDecoder().decode([Album].self, from: data) {
            return albums.first(where: { $0.id == id })
        } else {
            print("Failed to load album from batch file: \(batchFileName)")
        }

        return nil
    }
    
    func saveArtists(_ artists: [Artist]) {
        for artist in artists {
            let fileURL = artistsDirectory.appendingPathComponent("\(artist.id).json")

            do {
                let data = try JSONEncoder().encode(artist)
                try data.write(to: fileURL)
                print("Artist \(artist.name) saved successfully")
            } catch {
                print("Failed to save artist \(artist.name): \(error.localizedDescription)")
            }
        }
    }

    // Retrieve a specific artist by its ID
    func getArtist(id: String) -> Artist? {
        let fileURL = artistsDirectory.appendingPathComponent("\(id).json")

        if let data = try? Data(contentsOf: fileURL),
           let artist = try? JSONDecoder().decode(Artist.self, from: data) {
            return artist
        }
        return nil
    }
    
    func saveMisc(name: String, _ misc: any Codable) {
        let fileURL = miscDirectory.appendingPathComponent("\(name).json")
        
        do {
            let data = try JSONEncoder().encode(misc)
            try data.write(to: fileURL)
            print("Misc item \(name) saved successfully")
        } catch {
            print("Failed to save misc item \(name): \(error.localizedDescription)")
        }
    }
    
    func getMisc<T: Codable>(name: String, type: T.Type) -> T? {
        let fileURL = miscDirectory.appendingPathComponent("\(name).json")

        if let data = try? Data(contentsOf: fileURL),
           let misc = try? JSONDecoder().decode(T.self, from: data) {
            return misc
        }
        return nil
    }
}

extension Array {
    // Helper function to split an array into chunks
    func chunked(into size: Int) -> [[Element]] {
        var chunks: [[Element]] = []
        for i in stride(from: 0, to: self.count, by: size) {
            let chunk = Array(self[i..<Swift.min(i + size, self.count)])
            chunks.append(chunk)
        }
        return chunks
    }
}

