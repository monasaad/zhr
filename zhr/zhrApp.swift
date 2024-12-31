//
//  zhrApp.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI

@main
struct zhrApp: App {
    @State private var isActive: Bool = false  // State to control splash screen visibility
    @State private var hasShownOnboarding: Bool = false  // Track onboarding display

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if isActive {
                    if hasShownOnboarding {
                        MainTabView()  // Show main content on subsequent launches
                    } else {
                        OnBording()  // Show onboarding on first launch
                    }
                } else {
                    SplashScreen(isActive: $isActive, hasShownOnboarding: $hasShownOnboarding)
                }
            }
            .onAppear {
                // Check if the splash screen has been shown before
                hasShownOnboarding = UserDefaults.standard.bool(forKey: "hasShownOnboarding")
                
                // Set a delay to hide the splash screen
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { // 2 seconds delay
                    isActive = true
                    if !hasShownOnboarding {
                        UserDefaults.standard.set(true, forKey: "hasShownOnboarding") // Mark onboarding as shown
                    }
                }
            }
        }
    }
}

struct SplashScreen: View {
    @Binding var isActive: Bool
    @Binding var hasShownOnboarding: Bool
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0

    var body: some View {
        VStack {
            Image("ZHR")
                .resizable()
                .scaledToFit()
                .frame(width: 200, height: 200)
                .rotationEffect(.degrees(rotation))
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeInOut(duration: 1.0)) {
                        rotation = 360  // Rotate 360 degrees
                        opacity = 0.0  // Fade out
                    }
                }
        }
        .navigationBarBackButtonHidden(true)  // Hide back button
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

