import WatchConnectivity
import CoreLocation
import SwiftUI

class LocationManager: NSObject, ObservableObject, WCSessionDelegate {
    @Published var lastKnownLocation: CLLocation? = nil // Stores the location received from the Watch

    override init() {
        super.init()
        setupWatchConnectivity()
    }

    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("WCSession activated successfully on iPhone")
        }
    }

    // Handle messages from the Watch
    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let latitude = message["latitude"] as? Double,
           let longitude = message["longitude"] as? Double {
            DispatchQueue.main.async {
                self.lastKnownLocation = CLLocation(latitude: latitude, longitude: longitude)
                print("Received location from Watch: \(latitude), \(longitude)")
            }
        } else {
            print("Failed to parse location from Watch message")
        }
    }

    // Handle WCSession activation
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed on iPhone: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully on iPhone")
        }
    }

    // Required: Handle session becoming inactive
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive on iPhone")
    }

    // Required: Handle session deactivation
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession deactivated on iPhone")
        // Reactivate the session if necessary
        WCSession.default.activate()
    }
}
