import SwiftUI

struct ContentView1: View {
    @StateObject private var locationManager = WatchLocationManager()

    var body: some View {
        VStack {
            Text("Sending Location to iPhone...")
                .padding()
        }
        .onAppear {
            locationManager.setupWatchConnectivity()
        }
    }
}

#Preview {
    ContentView1()
}

