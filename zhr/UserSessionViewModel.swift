//
//  UserSessionViewModel.swift
//  zhr
//
//  Created by Razzan on 22/06/1446 AH.
//

import Foundation
import Combine

class UserSessionViewModel: ObservableObject {
    @Published var isSignedIn: Bool = false
    @Published var userName: String = ""

    func signIn(name: String) {
        userName = name
        isSignedIn = true // Update sign-in state
    }

    func signOut() {
        userName = ""
        isSignedIn = false // Update sign-out state
    }
}
