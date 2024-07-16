//
//  SignInViewModel.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import Foundation
import SwiftUI

class SignInViewModel : ObservableObject {
    @Published var viewList = NavigationPath()
    @Published var serverURL : String = ""
    @Published var connectedToServer : Bool = false
    @Published var errorMessage : String = ""
    
    init() {}
    
    func moveToFirstSignIn() {
        viewList.append(String(describing: SignInFirstView.self))
    }
    
    func connectToServer() {
        guard let url = URL(string: serverURL) else {
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data, error == nil else {
                return
            }
            
            do {
                let data
            } catch {
                
            }
        }
        
        viewList.append(String(describing: SignInSecondView.self))
    }
}
