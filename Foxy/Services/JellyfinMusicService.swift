//
//  JellyfinMusicService.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-09-26.
//

import Foundation
import JellyfinAPI
import Get
import UIKit

class JellyfinMusicService: ObservableObject {
    static var shared: JellyfinMusicService! = JellyfinMusicService()
    
    private var client: JellyfinClient?
    private var quickConnect: QuickConnect?
    
    @Published var quickConnectCode: String = ""
    @Published var quickConnectFailed: Bool = false
    @Published var isSignedIn: Bool = false
    
    private init() { }
    
    func configureClient(url: String, token: String?) {
        guard let newUrl = URL(string: url) else {
            print("Invalid URL provided")
            return
        }
        
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
    }
    
    static func initialize(url: String, token: String?) {
        shared.configureClient(url: url, token: token)
    }
    
    // Function to try and sign in using a stored access token if one exists
    static func trySignIn() -> Bool {
        guard let token = SecureStorage.shared.retrieve(key: "token"),
              let url = SecureStorage.shared.retrieve(key: "url") else {
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
    
    func getRecentlyListened(amount: Int?) async {
        let request = Request<BaseItemDtoQueryResult>(path: "items", method: .get)
        do {
            let result = try await client!.send(request)
            print(result)
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func getRecentlyPlayed(amount: Int?) {
        
    }
    
    func getRecentlyAdded(amount: Int?) {
        
    }

}
