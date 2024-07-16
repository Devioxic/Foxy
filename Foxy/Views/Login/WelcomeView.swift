//
//  WelcomeView.swift
//  Foxy
//
//  Created by Tilly Persson on 2024-07-13.
//

import SwiftUI

struct WelcomeView: View {
    @StateObject private var viewModel = SignInViewModel()
    
    var body: some View {
        NavigationStack(path: $viewModel.viewList) {
            GeometryReader { geometry in
                VStack {
                    Image("DevLogo")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(maxWidth: geometry.size.width / 1.75)
                        .padding(.top, geometry.size.height / 20)
                    Text("Welcome!")
                        .padding(.top, 50)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Mauris vel tristique turpis.")
                        .padding(.top, 1)
                        .padding(.horizontal, 20)
                    
                    Spacer()
                    NavigationButton(title: "Get Started", icon: nil) {
                        viewModel.moveToFirstSignIn()
                    }
                    .frame(height: 65)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
                .frame(width: geometry.size.width)
                
            }
            .navigationDestination(for: String.self) { id in
                if id == String(describing: SignInFirstView.self) {
                    SignInFirstView()
                } else if id == String(describing: SignInSecondView.self) {
                    SignInSecondView()
                }
            }
        }
        .environmentObject(viewModel)
    }
}

#Preview {
    WelcomeView()
}
