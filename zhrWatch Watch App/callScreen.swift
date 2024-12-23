//
//  callScreen.swift
//  zhr
//
//  Created by Huda Almadi on 22/12/2024.
//
import SwiftUI
import WatchConnectivity

struct WatchView: View {
    @State private var phoneNumber: String = "1234567890" // الرقم المرسل
    
    var body: some View {
        VStack {
            Text("Send Phone Number")
                .font(.headline)
            
            Button("Send to iPhone") {
                sendPhoneNumberToiPhone(phoneNumber)
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
    
    private func sendPhoneNumberToiPhone(_ phoneNumber: String) {
        if WCSession.isSupported() {
            let session = WCSession.default
            if session.isReachable {
                session.sendMessage(["phoneNumber": phoneNumber], replyHandler: nil) { error in
                    print("Error sending message: \(error.localizedDescription)")
                }
            } else {
                print("iPhone is not reachable")
            }
        }
    }
}

#Preview {
    WatchView()
}
