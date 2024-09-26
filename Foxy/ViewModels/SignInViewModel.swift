//
//  SignInViewModel.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import Foundation
import SwiftUI
import Alamofire

class SignInViewModel : ObservableObject {
    @Published var viewList = NavigationPath()
    @Published var serverURL : String = ""
    @Published var connectedToServer : Bool = false
    @Published var errorMessage : String = ""
    @Published var quickConnectCode : String = ""
    @Published var username : String = ""
    @Published var password : String = ""
    @Published var isQuickConnectEnabled : Bool = false
    @Published var showAlert : Bool = false
    
    private var authHeaders : HTTPHeaders = [
        "Authorization": "MediaBrowser Client=Foxy, Device=iOS, DeviceId=123456, Version=0.1.0",
        "Content-Type": "application/json"
    ]
    private var secret : String = ""
    
    init() {}
    
    func moveToFirstSignIn() {
        viewList.append(String(describing: SignInFirstView.self))
    }
    
    func successfulLogin() {
        print("Logging in")
    }
    
    func quickConnectSuccessful() {
        let parameters : [String : String] = [
            "Secret" : self.secret
        ]
        
        AF.request("\(self.serverURL)/Users/AuthenticateWithQuickConnect", method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseDecodable(of: QuickConnectAuthenticated.self) { response in
                switch response.result {
                case .success(let quickConnectResponse):
                    KeychainHelper.shared.save(quickConnectResponse.AccessToken, for: "accessToken")
                    self.connectedToServer = true
                    self.successfulLogin()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func checkQuickConnectStatus() {
        let timer = Timer(timeInterval: 3.0, repeats: true) { [weak self] timer in
            guard let self = self else {
                timer.invalidate()
                return
            }
            
            guard !self.connectedToServer else {
                timer.invalidate()
                return
            }
            
            AF.request("\(self.serverURL)/QuickConnect/Connect?secret=\(self.secret)", method: .get, headers: self.authHeaders)
                .validate()
                .responseDecodable(of: QuickConnect.self) { response in
                    switch response.result {
                    case .success(let quickConnect):
                        print(quickConnect)
                        if quickConnect.Authenticated {
                            self.quickConnectSuccessful()
                        }
                    case .failure(let error):
                        print(error)
                    }
                }
        }
        
        RunLoop.main.add(timer, forMode: .common)
    }
    
    func isQuickConnectionEnabled(completion: @escaping (Result<Bool, Error>) -> Void) {
        AF.request("\(serverURL)/QuickConnect/Enabled", method: .get, headers: authHeaders)
            .validate()
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    if let boolValue = value as? Bool {
                        completion(.success(boolValue))
                    } else {
                        completion(.success(false))
                    }
                case .failure(let error):
                    completion(.failure(error))
                }
            }
    }
    
    func initiateQuickConnect() {
        AF.request("\(serverURL)/QuickConnect/Initiate", method: .post, encoding: JSONEncoding.default, headers: authHeaders)
            .validate()
            .responseDecodable(of: QuickConnect.self) { response in
                switch response.result {
                case .success(let quickConnect):
                    print(quickConnect)
                    self.quickConnectCode = quickConnect.Code
                    self.secret = quickConnect.Secret
                    self.connectedToServer = quickConnect.Authenticated
                    self.checkQuickConnectStatus()
                case .failure(let error):
                    print(error)
                }
            }
    }
    
    func connectToServer() {
        self.isQuickConnectEnabled = false
        self.quickConnectCode = ""
        isQuickConnectionEnabled { result in
            switch result {
            case .success(let isEnabled):
                self.isQuickConnectEnabled = isEnabled
                self.initiateQuickConnect()
                self.viewList.append(String(describing: SignInSecondView.self))
            case .failure(let error):
                print(error)
                self.errorMessage = "Can't connect to server"
                self.showAlert = true
            }
        }
    }
}
