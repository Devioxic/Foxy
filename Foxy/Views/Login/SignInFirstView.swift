//
//  SignInFirstView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct SignInFirstView: View {
    @EnvironmentObject var viewModel : SignInViewModel
    @State var buttonLoading: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Image("Foxies")
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
                
                NavigationButton(title: "Continue", icon: nil, action: {
                    buttonLoading = true
                    Task {
                        await viewModel.connectToServer()
                        buttonLoading = false
                    }
                }, isLoading: $buttonLoading)
                .padding(20)
            }
            .alert(isPresented: $viewModel.showAlert) {
                Alert (
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}

#Preview {
    SignInFirstView()
        .environmentObject(SignInViewModel())
}
