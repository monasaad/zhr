import CoreLocation
import WatchConnectivity
import SwiftUI

#if os(watchOS)
import WatchKit
#endif

class WatchLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, WCSessionDelegate {
    
    private let locationManager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil

    #if os(watchOS)
    private var runtimeSession: WKExtendedRuntimeSession?
    #endif

    override init() {
        super.init()
        setupLocationManager()
        setupWatchConnectivity()
        
        #if os(watchOS)
        startExtendedRuntimeSession()
        #endif
    }

    // MARK: - Location Updates
    private func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        currentLocation = location
        print("Updated location on Watch: \(location.coordinate.latitude), \(location.coordinate.longitude)")
        sendLocationToPhone(location: location)
    }

    // MARK: - Watch Connectivity
    private func setupWatchConnectivity() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
            print("WCSession activated successfully on Watch")
        }
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

    // MARK: - Extended Runtime Session
    #if os(watchOS)
    private func startExtendedRuntimeSession() {
        runtimeSession = WKExtendedRuntimeSession()
        runtimeSession?.delegate = self
        runtimeSession?.start()
        print("Extended runtime session started.")
    }

    func extendedRuntimeSession(_ extendedRuntimeSession: WKExtendedRuntimeSession, didInvalidateWith reason: WKExtendedRuntimeSessionInvalidationReason, error: Error?) {
        print("Extended runtime session invalidated: \(reason.rawValue), error: \(String(describing: error?.localizedDescription))")
    }

    func extendedRuntimeSessionDidStart(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session started successfully.")
    }

    func extendedRuntimeSessionWillExpire(_ extendedRuntimeSession: WKExtendedRuntimeSession) {
        print("Extended runtime session will expire soon.")
    }
    #endif

    // MARK: - WCSessionDelegate
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed on Watch: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully on Watch")
        }
    }

    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession became inactive")
    }

    func sessionDidDeactivate(_ session: WCSession) {
        WCSession.default.activate() // Re-activate the session
        print("WCSession reactivated after deactivation")
    }

    func sessionReachabilityDidChange(_ session: WCSession) {
        print("WCSession reachability changed. Reachable: \(session.isReachable)")
    }
}
