import CoreLocation
import WatchConnectivity
import SwiftUI

class WatchLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, WCSessionDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestAlwaysAuthorization()
        setupWatchConnectivity()
        manager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        if let location = currentLocation {
            print("Updated location on Watch: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            sendLocationToPhone(location: location)
        }
    }

    // Send location to iPhone
    func sendLocationToPhone(location: CLLocation) {
        guard WCSession.default.isReachable else {
            print("iPhone is not reachable")
            return
        }

        let message: [String: Any] = [
            "latitude": location.coordinate.latitude,
            "longitude": location.coordinate.longitude
        ]
        WCSession.default.sendMessage(message, replyHandler: nil) { error in
            print("Error sending location to iPhone: \(error.localizedDescription)")
        }
        print("Sent location to iPhone: \(message)")
    }

    // Setup Watch Connectivity
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
            print("WCSession activated successfully on Watch")
        }
    }

    // WCSessionDelegate methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed on Watch: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully on Watch")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WCSession reachability changed: \(session.isReachable ? "Reachable" : "Not reachable")")
    }
}
