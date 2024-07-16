//
//  SignInFirstView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct SignInFirstView: View {
    @EnvironmentObject var viewModel : SignInViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("DevLogo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: geometry.size.width / 1.75)
                    .padding(.top, geometry.size.height / 20)
                Text("Sign in")
                    .padding(.top, 50)
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                VStack(alignment: .leading) {
                    Text("Server URL")
                        .padding(.horizontal, 30)
                    TextField("jellyfin.example.com", text: $viewModel.serverURL)
                        .padding(12)
                        .background(Color.textFieldColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                        .keyboardType(.URL)
                        .autocapitalization(/*@START_MENU_TOKEN@*/.none/*@END_MENU_TOKEN@*/)
                        .autocorrectionDisabled()
                }
                .padding(.top, 20)
                
                Spacer()
                
                NavigationButton(title: "Continue", icon: nil) {
                    viewModel.connectToServer()
                }
                .padding(20)
            }
        }
    }
}

#Preview {
    SignInFirstView()
        .environmentObject(SignInViewModel())
}
