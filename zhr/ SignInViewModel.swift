//
//   SignInViewModel.swift
//  zhr
//
//  Created by Razzan on 22/06/1446 AH.
//
import Foundation
import AuthenticationServices
class SignInViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var errorMessage: String? = nil
    
    func handleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
    }
    
    func handleCompletion(_ result: Result<ASAuthorization, Error>) {
        switch result {
        case .success(let authorization):
            processAuthorization(authorization)
        case .failure(let error):
            errorMessage = "Sign in failed: \(error.localizedDescription)"
            print(errorMessage ?? "Unknown error")
        }
    }
    
    private func processAuthorization(_ authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            errorMessage = "Invalid authorization credentials."
            return
        }
        
        let userId = appleIDCredential.user
        UserDefaults.standard.set(userId, forKey: "appleUserID")
        
        if let fullName = appleIDCredential.fullName {
            let givenName = fullName.givenName ?? "No given name"
            let familyName = fullName.familyName ?? "No family name"
            print("Name: \(givenName) \(familyName)")
        }
        
        if let email = appleIDCredential.email {
            print("Email: \(email)")
        }
        
        isSignedIn = true
    }
}
