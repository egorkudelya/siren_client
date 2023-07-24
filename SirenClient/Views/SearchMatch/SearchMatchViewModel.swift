import Foundation
import siren_package

class SearchMatchViewModel : NSObject, ObservableObject {
    @Published var captureViewModel = AudioCaptureViewModel()
    @Published var match: SearchMatch?
    @Published var isRecording = false
    @Published var isLoading = false
    @Published var isFailure = false
    private var requestTimestamp : CFAbsoluteTime = 0

    override init() {
        super.init()
    }
    
    public func matchFixedBuffer() {
        if !self.captureViewModel.startRecording() {
            self.isFailure = true
            return
        }
        
        self.isRecording = true

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(10), execute: {
            let path = self.captureViewModel.stopRecording()
            
            self.isRecording = false
            
            self.requestTimestamp = CFAbsoluteTimeGetCurrent()

            guard let coreResponse = SirenEngine.shared.processTrack(path),
                  let coreData = decodeJSON(coreResponse, to: SirenCoreResponse.self) else {
                self.isFailure = true
                return
            }

            if coreData.core_code != 0 {
                self.isFailure = true
                return
            }

            self.requestTrackMetadata(coreResponse: coreData)
        })
    
    }
        
    private func requestTrackMetadata(coreResponse: SirenCoreResponse) {
        self.isLoading = true
        NetworkManager.shared.getTrackMetadata(coreResponse: coreResponse){[self] result in
            DispatchQueue.main.async {
                self.isLoading = false
                
                switch result {
                case .success(var match):
                    if match.errors.isEmpty {
                        let adjustedTs = Double(match.timestamp) ?? 0 + (self.requestTimestamp - CFAbsoluteTimeGetCurrent()) * 1e3;
                        match.timestamp = Double(match.duration) ?? 0 < adjustedTs ? match.duration : String(adjustedTs)
                        self.match = match
                        return
                    }
    
                case .failure(let error):
                    switch error {
                    case .invalidData:
                        SirenLogger.shared.log(level: .error, "Received invalid data from the server")
                        
                    case .invalidURL:
                        SirenLogger.shared.log(level: .error, "Tried to access an invalid URL")
                        
                    case .invalidResponse:
                        SirenLogger.shared.log(level: .error, "Received an invalid response from the server")

                    case .unableToComplete:
                        SirenLogger.shared.log(level: .error, "Unable to complete the request")
                    }
                }
                self.isFailure = true
            }
        }
    }
}
   
