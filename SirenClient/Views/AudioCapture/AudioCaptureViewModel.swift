import Foundation
import AVFoundation

class AudioCaptureViewModel : NSObject, ObservableObject, AVAudioPlayerDelegate {
    @Published var isRecording = false
    @Published var isConfigured = false
    private let dateFormatter = DateFormatter()
    private var audioRecorder : AVAudioRecorder!
    
    override init() {
        super.init()
        self.configSession()
        dateFormatter.dateFormat = "dd-MM-YY_at_HH:mm:ss"
    }
    
    private func configSession() {
        let recordingSession = AVAudioSession.sharedInstance()
        let semaphore = DispatchSemaphore(value: 0)
        
        recordingSession.requestRecordPermission { granted in
            if granted {
                semaphore.signal()
            }
        }
        
        _ = semaphore.wait(timeout: .distantFuture)
        
        if recordingSession.recordPermission != AVAudioSession.RecordPermission.granted {
            SirenLogger.shared.log(level: .error, "Could not access device's microphone")
            return
        }
        
        do {
            try recordingSession.setCategory(.record, mode: .default)
            try recordingSession.setActive(true)
        }
        catch {
            SirenLogger.shared.log(level: .error, "Could not setup the recording")
            return
        }
                
        let fileUrl: URL = {
            let src = "sample\(dateFormatter.string(from: Date())).wav"
            return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(src)
        }()
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatLinearPCM),
            AVSampleRateKey: 48000,
            AVNumberOfChannelsKey: 2,
            AVLinearPCMBitDepthKey: 24,
            AVEncoderBitRateKey: 32000,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            self.audioRecorder = try AVAudioRecorder(url: fileUrl, settings: settings)
        }
        catch {
            SirenLogger.shared.log(level: .error, "Failed to setup the recording")
            return
        }
        self.isConfigured = true
    }
    
    func startRecording() -> Bool {
        if !self.isConfigured {
            return false
        }
        
        self.audioRecorder.prepareToRecord()
        self.audioRecorder.record()
        self.isRecording = true
        
        return true
    }
    
    func stopRecording() -> String {
        self.audioRecorder.stop()
        self.isRecording = false
        return audioRecorder.url.path
    }
    
}
