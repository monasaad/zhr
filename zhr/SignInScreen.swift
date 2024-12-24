import AuthenticationServices
//
//  SignInScreen.swift
//  zhr
//
//  Created by Razzan on 22/06/1446 AH.
//
import SwiftUI

struct SignInScreen: View {
    @StateObject private var viewModel = SignInViewModel()

    var body: some View {
        NavigationView {
            
            
            GeometryReader { geometry in
                VStack {
                    Image("ZHR")
                        .resizable()
                        .frame(width: 128, height: 128)
                    Spacer()
                        .frame(height: 300)
                    
                    SignInWithAppleButton(
                        onRequest: { request in
                            viewModel.handleRequest(request)
                        },
                        onCompletion: { result in
                            viewModel.handleCompletion(result)
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                    .frame(width: 331.33, height: 59)
                    .cornerRadius(16)
                    .shadow(radius: 4)
                    .accessibility(label: Text("Sign in with Apple"))  // accessibility label
                    
                    if viewModel.isSignedIn {
                        Text("You're signed in!")
                            .foregroundColor(.green)
                            .padding(.top, 20)
                    }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 20)
                    }
                    
                    NavigationLink(destination: MainTabView()) {
                        Text("Go to Main Tab View")
                    }
                }
                .padding()
                .padding()
                .background(Color(.systemBackground))
            }
            .padding(.top, 170)
        }
    }
}

struct SignInScreen_Previews: PreviewProvider {
    static var previews: some View {
        SignInScreen()
    }
}
