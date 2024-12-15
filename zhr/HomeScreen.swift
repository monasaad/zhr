//
//  HomeScreen.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI
import MapKit

struct HomeScreen: View {
    
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    var body: some View {
        Map(position: $position) {
            
        }
        .mapControls {
            MapUserLocationButton ()
        }
        .onAppear {
            CLLocationManager().requestWhenInUseAuthorization()
        }
    }
}


#Preview {
    HomeScreen()
}
