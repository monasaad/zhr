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
                healthDataView(title: "Steps", value: String(format: "%.1f km", totalSteps), icon: "figure.walk", color: .green)
                healthDataView(title: "Heart Rate", value: String(format: "%.1f bpm", averageHeartRate), icon: "heart", color: .red)
                healthDataView(title: "Sleep", value: String(format: "%.1f hours", totalSleep), icon: "bed.double", color: .purple)
                healthDataView(title: "Respiratory Rate", value: String(format: "%.1f %%", averageOxygen), icon: "lungs", color: .blue)
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
/*
import HealthKit
import SwiftUI

import SwiftUI

struct HealthScreen: View {
    @State private var totalSteps: Double = 0.0
    private var healthKitManager = HealthKitManager()

    var body: some View {
        VStack(alignment: .leading) {
            Text("Daily Activity")
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.bold)

            Text("Based on Apple Watch")
                .font(.system(.body, design: .rounded))
                .fontWeight(.medium)
                .foregroundColor(.gray)

            VStack(alignment: .leading) {
                HStack {
                    Spacer()
                    ZStack {
                        Circle()
                            .frame(width: 50, height: 50)
                            .foregroundColor(Color.white)
                        Image(systemName: "figure.walk")
                            .foregroundColor(.green)
                    }
                }
                Spacer()
                Text("\(totalSteps, specifier: "%.1f") km")
                    .font(.system(.headline, design: .rounded))
                Text("Steps")
                    .font(.system(.subheadline, design: .rounded))
            }
            .padding()
            .frame(width: 180, height: 180)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.purpleLight)
            )
            .cornerRadius(10)
        }
        .padding()
        .onAppear {
            healthKitManager.requestAuthorization { success in
                if success {
                    healthKitManager.fetchSteps { steps in
                        DispatchQueue.main.async {
                            self.totalSteps = steps
                        }
                    }
                }
            }
        }
    }
}

//struct HealthScreen: View {
//    var body: some View {
//        VStack(alignment: .leading) {
//            Text("Daily Activity")
//                .font(.largeTitle)
//                .fontWeight(.bold)
//
//            Text("Based on Apple Watch")
//                .font(.subheadline)
//                .foregroundColor(.gray)
//
//            VStack(alignment: .leading) {

//                HStack {
//                    Spacer()
//                    ZStack {
//                        Circle()
//                            .frame(width: 50, height: 50)
//                            .foregroundColor(Color.white)
//                        Image(systemName: "figure.walk")
//                            .foregroundColor(.green)
//                    }
//                }
//                Spacer()
//                Text("1.8 km")
//                    .font(.headline)
//                Text("Steps")
//                    .font(.subheadline)
//
 }.padding()
//                .frame(width: 180, height: 180)
//                .background(
//                    RoundedRectangle(cornerRadius: 20)
//                        .fill(.purpleLight)
//                )
//                .cornerRadius(10)
//        }.padding()
//    }
//}

#Preview {
    HealthScreen()
}
*/

