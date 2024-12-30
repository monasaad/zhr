import CoreLocation
import WatchConnectivity
import SwiftUI

class WatchLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, WCSessionDelegate {
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        setupWatchConnectivity()
        locationManager.startUpdatingLocation()
    }

    // CLLocationManagerDelegate method
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("Updated location on Watch: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        sendLocationToPhone(location: location)
    }

    private func sendLocationToPhone(location: CLLocation) {
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

    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("WCSession activated successfully on Watch")
        }
    }

    // WCSessionDelegate required methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed on Watch: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully on Watch")
        }
    }
}
