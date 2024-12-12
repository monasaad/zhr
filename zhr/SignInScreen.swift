//
//  ContentView.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI
import AuthenticationServices


struct SignInScreen: View {
    var body: some View {
        VStack {
            
            SignInWithAppleButton(
                onRequest: { request in
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                },
                onCompletion: { result in
                    /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Code@*/ /*@END_MENU_TOKEN@*/
                }
            ).signInWithAppleButtonStyle(.whiteOutline)
                .frame(height: 48)
        }
        .padding()
    }
}

#Preview {
    SignInScreen()
}
