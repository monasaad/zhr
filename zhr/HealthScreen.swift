//
//  HealthScreen.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI

struct HealthScreen: View {
    @State private var totalSteps: Double = 0.0
    @State private var averageHeartRate: Double = 0.0
    @State private var totalSleep: Double = 0.0
    @State private var averageOxygen: Double = 0.0
    private var healthKitManager = HealthKitManager()

    // Define grid layout
    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
    ]

    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Activity")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.top, 50)

            Text("Based on Apple Watch")
                .font(.headline)
                .foregroundColor(.gray)

            // Use LazyVGrid for two columns
            LazyVGrid(columns: columns, spacing: 20) {

                // Display Steps
                healthDataView(title: NSLocalizedString("Steps", comment: ""), value: String(format: NSLocalizedString("%.1f km", comment: ""), totalSteps), icon: "figure.walk", color: .green)
                //                healthDataView(title: "Steps", value: String(format: "%.1f km", totalSteps), icon: "figure.walk", color: .green)

                healthDataView(title: NSLocalizedString("Heart Rate", comment: ""), value: String(format: NSLocalizedString("%.1f bpm", comment: ""), averageHeartRate), icon: "heart", color: .red)

                healthDataView(title: NSLocalizedString("Sleep", comment: ""), value: String(format: NSLocalizedString("%.1f hours", comment: ""), totalSleep), icon: "bed.double", color: .purple)

                healthDataView(title: NSLocalizedString("Respiratory Rate", comment: ""), value: String(format: NSLocalizedString("%.1f %%", comment: ""), averageOxygen), icon: "lungs", color: .blue)
            }
            Spacer()
        }
        .padding(20)
        .onAppear {
            healthKitManager.requestAuthorization { success in
                if success {
                    healthKitManager.fetchSteps { steps in
                        DispatchQueue.main.async {
                            self.totalSteps = steps
                        }
                    }
                    healthKitManager.fetchHeartRate { heartRate in
                        DispatchQueue.main.async {
                            self.averageHeartRate = heartRate
                        }
                    }
                    healthKitManager.fetchSleep { sleep in
                        DispatchQueue.main.async {
                            self.totalSleep = sleep
                        }
                    }
                    healthKitManager.fetchBloodOxygen { bloodOxygen in
                        DispatchQueue.main.async {
                            self.averageOxygen = bloodOxygen
                        }
                    }
                }
            }
        }
    }

    private func healthDataView(title: String, value: String, icon: String, color: Color) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Spacer()
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.white)
                    Image(systemName: icon)
                        .foregroundColor(color)
                }
            }
            Spacer()
            Text(value)
                .font(.headline)
            Text(title)
                .font(.subheadline)
        }
        .padding()
        .frame(width: 170, height: 170)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.purpleLight)
        )
    }
}

#Preview {
    HealthScreen()
}
