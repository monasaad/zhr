//
//  callScreen2.swift
//  zhr
//
//  Created by Huda Almadi on 22/12/2024.
//
import SwiftUI
import WatchConnectivity
import AVFoundation

// ContentView لتسجيل الصوت وإرساله
struct ContentView: View {
    @State private var audioDataReceived: Data?
    @State private var isRecording = false
    @State private var recorder: AVAudioRecorder?

    var body: some View {
        VStack {
            Button(action: {
                if self.isRecording {
                    // إيقاف التسجيل
                    self.stopRecording()
                } else {
                    // بدء التسجيل
                    self.startRecording()
                }
            }) {
                Text(isRecording ? "Stop Recording" : "Press and Hold to Record")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isRecording ? Color.red : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding()

            // عرض الصوت المستلم من الساعة
            if let audioData = audioDataReceived {
                Text("Audio received!")
                    .font(.subheadline)
                    .padding()
                // إذا كنت بحاجة لعرض أو تشغيل الصوت، يمكنك إضافته هنا
            }
        }
        .onAppear {
            WatchSessionManager.shared.onMessageReceived = { message in
                if let audioData = message["audio"] as? Data {
                    // استلام الصوت من الساعة على الـ iPhone
                    self.audioDataReceived = audioData
                }
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
            print("Error starting audio recorder: \(error.localizedDescription)")
        }
    }
    
    // إيقاف التسجيل وإرسال الصوت إلى الساعة
    func stopRecording() {
        recorder?.stop()
        isRecording = false
        
        guard let recorder = recorder else { return }
        
        let url = recorder.url
        sendAudioToWatch(url: url)
    }
    
    // إرسال الصوت إلى الساعة
    func sendAudioToWatch(url: URL) {
        if WCSession.default.isReachable {
            do {
                let audioData = try Data(contentsOf: url)
                WCSession.default.sendMessage(["audio": audioData], replyHandler: nil, errorHandler: nil)
            } catch {
                print("Error sending audio data: \(error.localizedDescription)")
            }
        }
    }
}

// WatchSessionManager لتفعيل اتصال الـ WCSession بين الساعة والـ iPhone
class WatchSessionManager: NSObject, WCSessionDelegate {
    static let shared = WatchSessionManager()
    
    var onMessageReceived: (([String: Any]) -> Void)?
    
    private override init() {
        super.init()
        if WCSession.isSupported() {
            let session = WCSession.default
            session.delegate = self
            session.activate()
        }
    }
    
    // تنفيذ الدالة لتفعيل WCSession
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        if let error = error {
            print("Activation failed with error: \(error.localizedDescription)")
        } else {
            print("WCSession activated.")
        }
    }
    
    // استلام الرسائل
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        onMessageReceived?(message)
    }
    
    // استلام البيانات (مثل الصوت أو الملفات)
    func session(_ session: WCSession, didReceive message: [String : Any]) {
        onMessageReceived?(message)
    }
    
    func sessionDidBecomeInactive(_ session: WCSession) {}
    
    func sessionDidDeactivate(_ session: WCSession) {}
}

// Preview لـ ContentView
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .previewDevice("iPhone 15") // تحديد جهاز iPhone المناسب للاختبار
            .previewLayout(.sizeThatFits) // لتناسب المحتوى
            .frame(width: 300, height: 300) // تحديد الحجم المناسب للعرض
    }
}
