import MapKit
import SwiftUI

struct HomeScreen: View {
    @State private var position: MapCameraPosition = .userLocation(fallback: .camera(MapCamera(centerCoordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0), distance: 1000)))
    @StateObject private var locationManager = LocationManager()

    var body: some View {
        ZStack {
            Map(position: $position) {
                Annotation("User Location", coordinate: locationManager.lastKnownLocation?.coordinate ?? CLLocationCoordinate2D(latitude: 0, longitude: 0)) {
                    Circle()
                        .fill(Color.blue)
                        .frame(width: 12, height: 12)
                }
            }
            .ignoresSafeArea()

            VStack {
                Spacer()
                Button(action: {
                    centerOnUserLocation()
                }) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(red: 106 / 255, green: 89 / 255, blue: 172 / 255))
                            .frame(width: 331.33, height: 59)
                        
                        Image(systemName: "location.fill")
                            .padding(.trailing, 170.0)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                        
                        Text("Current Location")
                            .font(.headline)
                            .foregroundColor(.white)
                    }
                }
                .padding(.bottom, 16)
            }
        }
        .onAppear {
            locationManager.requestLocationPermission()
            if let location = locationManager.lastKnownLocation {
                centerOnUserLocation() // Center immediately if location is available
            }
        }
    }
    
    private func centerOnUserLocation() {
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
            print("User location not available yet.")
        }
    }
}

//class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
//    private let manager = CLLocationManager()
//    @Published var lastKnownLocation: CLLocation? = nil
//
//    override init() {
//        super.init()
//        manager.delegate = self
//    }
//
//    func requestLocationPermission() {
//        manager.requestWhenInUseAuthorization()
//        manager.startUpdatingLocation()
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        lastKnownLocation = locations.last
//    }
//
//    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
//        if manager.authorizationStatus == .authorizedWhenInUse || manager.authorizationStatus == .authorizedAlways {
//            manager.startUpdatingLocation()
//        } else {
//            print("Location permissions not granted.")
//        }
//    }
//}

#Preview {
    HomeScreen()
}
//import SwiftUI
//import MapKit
//
//struct HomeScreen: View {
//    @State private var region = MKCoordinateRegion(
//        center: CLLocationCoordinate2D(latitude: 0, longitude: 0),
//        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
//    )
//    @StateObject private var locationManager = LocationManager()
//
//    var body: some View {
//        ZStack {
//            // Map displaying the last known location
//            Map(coordinateRegion: $region, showsUserLocation: false, annotationItems: locationManager.annotationItems) { item in
//                MapAnnotation(coordinate: item.coordinate) {
//                    Circle()
//                        .fill(Color.blue)
//                        .frame(width: 12, height: 12)
//                }
//            }
//            .ignoresSafeArea()
//
//            // Center Button
//            VStack {
//                Spacer()
//                Button("Current Location") {
//                    centerOnWatchLocation()
//                }
//                .padding()
//                .background(Color.blue)
//                .foregroundColor(.white)
//                .cornerRadius(10)
//                .padding(.bottom, 20)
//            }
//        }
//        .onChange(of: locationManager.lastKnownLocation) { location in
//            guard let location = location else { return }
//            updateRegion(for: location)
//        }
//    }
//
//    private func centerOnWatchLocation() {
//        guard let location = locationManager.lastKnownLocation else {
//            print("No location available to center on.")
//            return
//        }
//        updateRegion(for: location)
//    }
//
//    private func updateRegion(for location: CLLocation) {
//        region.center = location.coordinate
//    }
//}
//
//extension LocationManager {
//    var annotationItems: [AnnotationItem] {
//        guard let location = lastKnownLocation else { return [] }
//        return [AnnotationItem(coordinate: location.coordinate)]
//    }
//}
//
//struct AnnotationItem: Identifiable {
//    let id = UUID()
//    let coordinate: CLLocationCoordinate2D
//}
