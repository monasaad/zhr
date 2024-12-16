import SwiftUI
import MapKit

struct HomeScreen: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1000)))
    @StateObject private var locationManager = LocationManager() // For managing location updates

    var body: some View {
        ZStack {
            // Map View
            Map(position: $position) {
                // Show the user's location
                Annotation("User Location", coordinate: locationManager.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12) // Represent user's location with a small circle
                }
            }
            .ignoresSafeArea() // Make the map cover the whole screen
            
            // User Location Button in a Rectangle
            VStack {
                Spacer() // Push the button to the bottom
                
                Button(action: {
                    centerOnUserLocation()
                }) {
                    ZStack {
                        // Background rectangle
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 106 / 255, green: 89 / 255, blue: 172 / 255)) // Hex #6A59AC
                            .frame(width: 331.33, height: 59)
                         
                        // Add the SF Symbol as an icon
                        Image(systemName: "location.fill")
                            .padding(.trailing, 170.0) // Navigator icon
                                            .font(.system(size: 20)) // Adjust size
                                            .foregroundColor(.white) // Icon color
                        
                        // Text inside the rectangle
                        Text("Current Location")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 16) // Add spacing at the bottom
            }
        }
        .onAppear {
            locationManager.requestLocationPermission() // Request location permissions
        }
    }
    
    // Center the map on the user's location
    private func centerOnUserLocation() {
        if let location = locationManager.lastKnownLocation {
            position = .camera(
                MapCamera(
                    centerCoordinate: location.coordinate,
                    distance: 500, // Adjust the zoom level
                    heading: 0,
                    pitch: 0
                )
            )
        } else {
            print("User location not available yet.")
        }
    }
}

// Persistent Location Manager
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private let manager = CLLocationManager()
    @Published var lastKnownLocation: CLLocation? = nil

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocationPermission() {
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        lastKnownLocation = locations.last
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
            manager.startUpdatingLocation()
        } else {
            print("Location permissions not granted.")
        }
    }
}


#Preview {
    HomeScreen()
}
