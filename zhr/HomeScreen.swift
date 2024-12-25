import SwiftUI
import MapKit

struct HomeScreen: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            // Map displaying the last known location
            Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: locationManager.annotationItems) { item in
                MapAnnotation(coordinate: item.coordinate) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                }
            }
            .ignoresSafeArea()

            // Center Button
            VStack {
                Spacer()
                Button("Current Location") {
                    centerOnWatchLocation()
                }
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .padding(.bottom, 20)
            }
        }
        .onChange(of: locationManager.lastKnownLocation) { location in
            guard let location = location else { return }
            updateRegion(for: location)
        }
    }

    private func centerOnWatchLocation() {
        guard let location = locationManager.lastKnownLocation else {
            print("No location available to center on.")
            return
        }
        updateRegion(for: location)
    }

    private func updateRegion(for location: CLLocation) {
        region.center = location.coordinate
    }
}

extension LocationManager {
    var annotationItems: [AnnotationItem] {
        guard let location = lastKnownLocation else { return [] }
        return [AnnotationItem(coordinate: location.coordinate)]
    }
}

struct AnnotationItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}
