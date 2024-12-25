//
//  UserSessionViewModel.swift
//  zhr
//
//  Created by Razzan on 22/06/1446 AH.
//

import Foundation
import AuthenticationServices

class UserSession {
    private let userIdKey = "AppleUserID"

    var isSignedIn: Bool {
        return loadUserId() != nil
    }

    func signIn(appleIDCredential: ASAuthorizationAppleIDCredential) {
        let userId = appleIDCredential.user
        saveUserId(userId)
    }

    func signOut() {
        clearUserId()
    }

    private func saveUserId(_ userId: String) {
        UserDefaults.standard.set(userId, forKey: userIdKey)
    }

    private func loadUserId() -> String? {
        return UserDefaults.standard.string(forKey: userIdKey)
    }

    private func clearUserId() {
        UserDefaults.standard.removeObject(forKey: userIdKey)
    }
}
