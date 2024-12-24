import WatchConnectivity
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var lastKnownLocation: CLLocation? = nil // Stores the location received from the Apple Watch

    override init() {
        super.init()
        setupWatchConnectivity() // Initialize WatchConnectivity
    }

    // Setup WatchConnectivity
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
    }

    // Handle incoming messages (e.g., location updates) from the Apple Watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let latitude = message["latitude"] as? Double,
           let longitude = message["longitude"] as? Double {
            DispatchQueue.main.async {
                self.lastKnownLocation = CLLocation(latitude: latitude, longitude: longitude)
                print("Received location from watch: \(latitude), \(longitude)")
            }
        }
    }

    // Handle WCSession activation
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully!")
        }
    }

    // Handle WCSession state changes (mandatory methods)
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive.")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated.")
        WCSession.default.activate() // Reactivate session if necessary
    }
}
