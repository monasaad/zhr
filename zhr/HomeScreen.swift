import SwiftUI
import MapKit

struct HomeScreen: View {
    @State private var position: MapCameraPosition = .userLocation(
        fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1000))
    )
    @StateObject private var locationManager = LocationManager() // Handles WatchConnectivity and location data

    var body: some View {
        ZStack {
            // Map View
            Map(position: $position) {
                if let coordinate = locationManager.lastKnownLocation?.coordinate {
                    Annotation("Remote User Location", coordinate: coordinate) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12) // Show Watch location as a small circle
                    }
                }
            }
            .ignoresSafeArea()

            // Center Button
            VStack {
                Spacer()
                Button(action: {
                    centerOnRemoteLocation()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.blue)
                            .frame(width: 250, height: 50)
                        Text("Center on Watch Location")
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            locationManager.setupWatchConnectivity()
        }
    }

    private func centerOnRemoteLocation() {
        if let location = locationManager.lastKnownLocation {
            position = .camera(
                MapCamera(
                    centerCoordinate: location.coordinate,
                    distance: 500,
                    heading: 0,
                    pitch: 0
                )
            )
        } else {
            print("No location data available.")
        }
    }
}
