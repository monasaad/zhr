import SwiftUI
import MapKit

struct ContentView1: View {
    @StateObject private var locationManager = WatchLocationManager()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )

    var body: some View {
        VStack {
            if let location = locationManager.currentLocation {
                Map(coordinateRegion: $region, showsUserLocation: true)
                    .onAppear {
                        updateRegion(for: location)
                    }
                    .onChange(of: location) { newLocation in
                        updateRegion(for: newLocation)
                    }
            } else {
                Text("Waiting for location...")
                    .padding()
            }
        }
    }

    private func updateRegion(for location: CLLocation) {
        region.center = location.coordinate
    }
}
