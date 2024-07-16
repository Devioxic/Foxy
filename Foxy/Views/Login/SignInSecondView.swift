//
//  SignInSecondView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-14.
//

import SwiftUI

struct SignInSecondView: View {
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
                    Text("Username")
                        .padding(.horizontal, 30)
                    TextField("Demo", text: $viewModel.serverURL)
                        .padding(12)
                        .background(Color.textFieldColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 20)
                
                VStack(alignment: .leading) {
                    Text("Password")
                        .padding(.horizontal, 30)
                    SecureField("", text: $viewModel.serverURL)
                        .padding(12)
                        .background(Color.textFieldColor)
                        .cornerRadius(12)
                        .padding(.horizontal, 20)
                }
                .padding(.top, 10)
                
                Spacer()
                
                NavigationButton(title: "Continue", icon: nil) {
                    
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
            }
        }
    }
}

#Preview {
    SignInSecondView()
        .environmentObject(SignInViewModel())
}
