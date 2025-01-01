//
//  zhrWatchApp.swift
//  zhrWatch Watch App
//
//  Created by Huda Almadi on 22/12/2024.
//

//
//  zhrWatchApp.swift
//  zhrWatch Watch App
//
//  Created by Huda Almadi on 22/12/2024.
//

import SwiftUI
import WatchKit

@main
struct zhrWatchApp: App {
    // Connect the WatchKit extension delegate
    @WKExtensionDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        WindowGroup {
            
            Content()  // Use a SwiftUI view here
        }
    }
}

// AppDelegate for handling lifecycle and background tasks
class AppDelegate: NSObject, WKExtensionDelegate {
    func applicationDidFinishLaunching() {
        print("Watch App Launched")
    }

    func handle(_ backgroundTasks: Set<WKRefreshBackgroundTask>) {
        for task in backgroundTasks {
            if let connectivityTask = task as? WKWatchConnectivityRefreshBackgroundTask {
                print("Handling Watch Connectivity Background Task")
                connectivityTask.setTaskCompletedWithSnapshot(false)
            } else {
                task.setTaskCompletedWithSnapshot(false)
            }
        }
    }
}
