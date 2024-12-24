import CoreLocation
import WatchConnectivity

class WatchLocationManager: NSObject, ObservableObject, CLLocationManagerDelegate, WCSessionDelegate {
    private let manager = CLLocationManager()
    @Published var currentLocation: CLLocation? = nil

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.activityType = .fitness
        manager.requestAlwaysAuthorization()
        setupWatchConnectivity()
    }

    func startUpdatingLocation() {
        manager.startUpdatingLocation()
    }

    func stopUpdatingLocation() {
        manager.stopUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        currentLocation = locations.last
        if let location = currentLocation {
            sendLocationToPhone(location: location)
        }
    }

    // Send the location to the iPhone
    func sendLocationToPhone(location: CLLocation) {
        if WCSession.default.isReachable {
            let message: [String: Any] = [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ]
            WCSession.default.sendMessage(message, replyHandler: nil) { error in
                print("Error sending location: \(error.localizedDescription)")
            }
        }
    }

    // Setup WatchConnectivity
    func setupWatchConnectivity() {
        if WCSession.isSupported() {
            WCSession.default.delegate = self // Assign the delegate
            WCSession.default.activate()
        }
    }

    // MARK: - WCSessionDelegate Methods

    // Called when the session activation state changes
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated successfully with state: \(activationState.rawValue)")
        }
    }
}
