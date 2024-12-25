//
//
//  SignInScreen.swift
//  zhr
//
//  Created by Razzan on 22/06/1446 AH.
//
import SwiftUI
import AuthenticationServices

struct SignInScreen: View {
    @StateObject private var viewModel = SignInViewModel()

    var body: some View {
        NavigationStack {
            
            
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
                            // Check if the sign-in is successful and update the state
                            if case .success = result {
                                viewModel.isSignedIn  = true
                            }
                        }
                    )
                    .signInWithAppleButtonStyle(.black)
                            .frame(width: 331.33, height: 59)
                            .cornerRadius(16)
                            .shadow(radius: 4)
                            .accessibility(label: Text("Sign in with Apple"))
                    
                    // NavigationLink that activates when signed in
                    NavigationLink(destination: MainTabView()){
                                           //isActive: $viewModel.isSignedIn ) {
                                
                                EmptyView()
                            }
                    
                    if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding(.top, 20)
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

#Preview {
    SignInScreen()
}
