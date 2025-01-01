import Foundation
import CoreLocation
import WatchConnectivity
import SwiftUI

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, WCSessionDelegate {
    private let locationManager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation? = nil
    @Published var isReachable: Bool = false

    override init() {
        super.init()
        setupLocationManager()
        setupWatchConnectivity()
    }

    // MARK: - Location Updates
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        DispatchQueue.main.async {
            self.lastKnownLocation = location
        }
    }

    // MARK: - Watch Connectivity
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }

    func checkReachability() {
        DispatchQueue.main.async {
            self.isReachable = WCSession.default.isReachable
        }
    }

    // MARK: - WCSessionDelegate Methods
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully. Activation state: \(activationState.rawValue)")
        }
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        DispatchQueue.main.async {
            self.isReachable = session.isReachable
        }
    }

    // MARK: - Placeholder Methods for Protocol Conformance
    // These are required by the protocol but can remain empty if not needed
    func sessionDidBecomeInactive(_ session: WCSession) {
        // Placeholder for sessionDidBecomeInactive
    }

    func sessionDidDeactivate(_ session: WCSession) {
        // Placeholder for sessionDidDeactivate
    }
}





//class LocationManager: NSObject, ObservableObject, WCSessionDelegate {
//    @Published var lastKnownLocation: CLLocation? = nil // Stores the location received from the Watch
//
//    override init() {
//        super.init()
//        setupWatchConnectivity()
//    }
//
//    func setupWatchConnectivity() {
//        if WCSession.isSupported() {
//            WCSession.default.delegate = self
//            WCSession.default.activate()
//            print("WCSession activated successfully on iPhone")
//        }
//    }
//
//    // Handle messages from the Watch
//    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
//        guard let latitude = message["latitude"] as? Double,
//              let longitude = message["longitude"] as? Double else {
//            print("Failed to parse location from Watch message")
//            return
//        }
//
//        DispatchQueue.main.async {
//            self.lastKnownLocation = CLLocation(latitude: latitude, longitude: longitude)
//            print("Received location from Watch: \(latitude), \(longitude)")
//        }
//    }
//
//    // Handle WCSession activation
//    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
//        if let error = error {
//            print("WCSession activation failed on iPhone: \(error.localizedDescription)")
//        } else {
//            print("WCSession activated successfully on iPhone")
//        }
//    }
//
//    // Handle session becoming inactive
//    func sessionDidBecomeInactive(_ session: WCSession) {
//        print("WCSession became inactive on iPhone")
//    }
//
//    // Handle session deactivation
//    func sessionDidDeactivate(_ session: WCSession) {
//        print("WCSession deactivated on iPhone")
//        // Reactivate the session if necessary
//        WCSession.default.activate()
//    }
//}
