//
//  HealthScreen.swift
//  zhr
//
//  Created by Mona on 12/12/2024.
//

import SwiftUI

struct HealthScreen: View {
    var body: some View {
        Text("Daily Activity")
        Text("Based on Apple Watch")
        ZStack {
            Rectangle()
                .fill(Color.purple)  // Set the fill color
                .frame(width: 180, height: 180)  // Set custom width and height
                .cornerRadius(10)  // Optional: add corner radius
                .padding()
            VStack {
                Circle().frame(width: 100, height: 100).foregroundColor(Color.white)
                Text("1.8 km")
                Text("Steps")
            }

        }

    }
}

#Preview {
    HealthScreen()
}
