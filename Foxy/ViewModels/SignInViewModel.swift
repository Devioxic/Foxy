//
//  SignInViewModel.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import Foundation
import SwiftUI
import JellyfinAPI

class SignInViewModel : ObservableObject {
    @Published var viewList = NavigationPath()
    @Published var serverURL : String = ""
    @Published var errorMessage : String = ""
    @Published var quickConnectCode : String = ""
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var quickConnectFailed : Bool = false
    @Published var showAlert : Bool = false
            
    init() {
        observequickConnect()
    }
    
    private func observequickConnect() {
            JellyfinMusicService.shared.$quickConnectCode
                .assign(to: &$quickConnectCode)

            JellyfinMusicService.shared.$quickConnectFailed
                .assign(to: &$quickConnectFailed)
    }
    
    @MainActor
    private func isValidUrl(_ urlString: String) async -> Bool {
        guard let url = URL(string: urlString),
              let scheme = url.scheme, ["http", "https"].contains(scheme),
              url.host != nil else {
            errorMessage = "Invalid URL"
            return false
        }
        
        // Send a request to the server to make sure it exists
        let request = URLRequest(url: url)
        
        do {
            let (_, response) = try await URLSession.shared.data(for: request)

            // Check if the response is an HTTP response and validate the status code
            if let httpResponse = response as? HTTPURLResponse {
                if (200..<300).contains(httpResponse.statusCode) {
                    return true
                } else {
                    errorMessage = "Invalid response status: \(httpResponse.statusCode). Wrong URL?"
                    return false
                }
            } else {
                errorMessage = "No valid HTTP response received. Wrong URL?co"
                return false
            }
        } catch {
            errorMessage = "Couldn't connect to the server. Wrong URL?"
            return false
        }
    }
    
    func moveToFirstSignIn() {
        viewList.append(String(describing: SignInFirstView.self))
    }
    
    @MainActor
    func connectToServer() async {
        let isValid = await isValidUrl(serverURL)
        
        guard isValid else {
            showAlert = true
            return
        }
            
        JellyfinMusicService.initialize(url: serverURL, token: nil)
        
        JellyfinMusicService.shared.setupQuickConnect()
        JellyfinMusicService.shared.startQuickConnect()
        
        viewList.append(String(describing: SignInSecondView.self))
    }
    
    func signInUsingCredentials() async {
        let (success, message) = await JellyfinMusicService.shared.signInUsingCreditentials(username: username, password: password)
        
        guard success else {
            errorMessage = message!
            showAlert = true
            return
        }
    }
}
