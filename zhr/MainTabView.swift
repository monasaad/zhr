//
//  MainTabView.swift
//  zhr
//
//  Created by Mona on 16/12/2024.
//
import SwiftUI
import UserNotifications

struct MainTabView: View {
    var body: some View {
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
        .navigationBarBackButtonHidden(true)
        .onAppear {
            requestNotificationPermission()
        }
    }

    func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if granted {
                print("Permission granted")
            } else {
                print("Permission denied or not determined")
            }
        }
    }
}

#Preview {
    MainTabView()
}
