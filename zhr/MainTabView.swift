//
//  MainTabView.swift
//  zhr
//
//  Created by Mona on 16/12/2024.
//


import SwiftUI

struct SplashScreen: View {
    @State private var rotation: Double = 0
    @State private var opacity: Double = 1.0
    @Binding var isActive: Bool

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
                        rotation = 360 // Rotate 360 degrees
                        opacity = 0.0 // Fade out
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        isActive = true // Transition after animation
                    }
                }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}

struct MainTabView: View {
    @State private var isActive = false // State to control splash screen

    var body: some View {
        Group {
            if isActive {
                TabView {
                    HomeScreen()
                        .tabItem {
                            Image(systemName: "location.fill")
                            Text("Location")
                        }
                    
                    HealthScreen()
                        .tabItem {
                            Image(systemName: "heart.fill")
                            Text("Health")
                        }
                    
                    ReminderScreen()
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("Reminder")
                        }
                    
                    ActivityScreen()
                        .tabItem {
                            Image(systemName: "dice.fill")
                            Text("Activity")
                        }
                }
            } else {
                SplashScreen(isActive: $isActive) // Show splash screen
            }
        }
    }
}

#Preview {
    MainTabView()
}
