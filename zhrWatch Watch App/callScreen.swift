//
//  callScreen.swift
//  zhr
//
//  Created by Huda Almadi on 22/12/2024.
//


import SwiftUI
import WatchConnectivity
import AVFoundation

struct CallScreen: View {
    @State private var isRecording = false
    @State private var recorder: AVAudioRecorder?

    var body: some View {
        VStack {
            Button(action: {
                // لا حاجة لتعريف أي فعل هنا، كل شيء يتم مع الضغط المطول.
            }) {
                Text(isRecording ? "Recording..." : "Press and Hold to Speak")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()
            .simultaneousGesture(LongPressGesture(minimumDuration: 1.0).onChanged { _ in
                if !isRecording { // التأكد من أنه لم يبدأ التسجيل بعد
                    startRecording()
                }
            }.onEnded { _ in
                stopRecordingAndSendAudio()
            })
        }
        .onAppear {
            WatchSessionManager.shared.onMessageReceived = { message in
                // معالجة الرسائل إن لزم الأمر
            }
        }
    }
    
    // بدء التسجيل الصوتي
    func startRecording() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.record, mode: .default)
            try audioSession.setActive(true)
            
            let settings: [String: Any] = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 12000,
                AVNumberOfChannelsKey: 1,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            let url = FileManager.default.temporaryDirectory.appendingPathComponent("recording.m4a")
            recorder = try AVAudioRecorder(url: url, settings: settings)
            recorder?.record()
            
            isRecording = true
        } catch {
            // إذا حدث خطأ، لا نقوم بطباعة أي شيء هنا
        }
    }
    
    // إيقاف التسجيل وإرسال الصوت إلى الـ iPhone
    func stopRecordingAndSendAudio() {
        recorder?.stop()
        isRecording = false
        
        guard let recorder = recorder else { return }
        
        let url = recorder.url
        sendAudioToPhone(url: url)
    }
    
    // إرسال الصوت إلى الـ iPhone
    func sendAudioToPhone(url: URL) {
        if WCSession.default.isReachable {
            do {
                let audioData = try Data(contentsOf: url)
                WCSession.default.sendMessage(["audio": audioData], replyHandler: nil, errorHandler: nil)
            } catch {
                // لا نطبع أي رسائل عند حدوث خطأ
            }
        }
    }
}

class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    var onMessageReceived: ((String) -> Void)?
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        // تم إلغاء استخدام الطباعة
    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        if let audioData = message["audio"] as? Data {
            // التعامل مع الصوت المستلم من الساعة على الـ iPhone
        }
    }
}


