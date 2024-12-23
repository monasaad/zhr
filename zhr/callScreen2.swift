//
//  callScreen2.swift
//  zhr
//
//  Created by Huda Almadi on 22/12/2024.
//

import SwiftUI
import WatchConnectivity

struct CallScreen2: View {
    @State private var receivedPhoneNumber: String = "" // الرقم المستلم
    
    var body: some View {
        VStack {
            Text("Received Phone Number:")
                .font(.headline)
            Text(receivedPhoneNumber.isEmpty ? "Waiting for a number..." : receivedPhoneNumber)
                .font(.title)
                .foregroundColor(receivedPhoneNumber.isEmpty ? .gray : .blue)
                .padding()
            
            Spacer()
            
            if !receivedPhoneNumber.isEmpty {
                Button(action: {
                    makePhoneCall(to: receivedPhoneNumber)
                }) {
                    Text("Call \(receivedPhoneNumber)")
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding()
            }
        }
        .padding()
        .onAppear {
            setupWCSession()
        }
    }
    
    // تفعيل WCSession
    private func setupWCSession() {
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = WCSessionDelegateHandler(receivedPhoneNumber: $receivedPhoneNumber)
            session.activate()
        }
    }
    
    // إجراء المكالمة
    private func makePhoneCall(to phoneNumber: String) {
        if let phoneURL = URL(string: "tel://\(phoneNumber)"),
           UIApplication.shared.canOpenURL(phoneURL) {
            UIApplication.shared.open(phoneURL, options: [:], completionHandler: nil)
        } else {
            print("Unable to make the call.")
        }
    }
}

// جلسة الاتصال بالساعة
class WCSessionDelegateHandler: NSObject, WCSessionDelegate {
    @Binding var receivedPhoneNumber: String
    
    init(receivedPhoneNumber: Binding<String>) {
        _receivedPhoneNumber = receivedPhoneNumber
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("WCSession activation failed: \(error.localizedDescription)")
        } else {
            print("WCSession activated with state: \(activationState.rawValue)")
        }
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {
        print("WCSession did become inactive.")
    }
    
    func sessionDidDeactivate(_ session: WCSession) {
        print("WCSession did deactivate.")
        WCSession.default.activate()
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        if let phoneNumber = message["phoneNumber"] as? String {
            DispatchQueue.main.async {
                self.receivedPhoneNumber = phoneNumber
            }
        }
    }
}

#Preview {
    CallScreen2()
}
