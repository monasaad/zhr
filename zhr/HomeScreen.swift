import SwiftUI
import MapKit

struct HomeScreen: View {
    @State private var position: MapCameraPosition = .userLocation(
        fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1000))
    )
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            // Map displaying the last known location
            Map(position: $position) {
                if let coordinate = locationManager.lastKnownLocation?.coordinate {
                    Annotation("Watch Location", coordinate: coordinate) {
                        Circle()
                            .fill(Color.blue)
                            .frame(width: 12, height: 12) // Show location as a small circle
                    }
                }
            }
            .ignoresSafeArea()

            // Center Button
            VStack {
                Spacer()
                Button("Center on Watch Location") {
                    centerOnWatchLocation()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
        }
        .onAppear {
            locationManager.setupWatchConnectivity()
        }
    }

    private func centerOnWatchLocation() {
        if let location = locationManager.lastKnownLocation {
            position = .camera(
                MapCamera(
                    centerCoordinate: location.coordinate,
                    distance: 500,
                    heading: 0,
                    pitch: 0
                )
            )
        }
    }
}
