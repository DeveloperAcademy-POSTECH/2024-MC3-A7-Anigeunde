//
//  File.swift
//  Lvlance
//
//  Created by 이종선 on 7/30/24.
//

import SwiftUI
import Combine
import SoundAnalysis

class AppState: ObservableObject {

    private var detectionCancellable: AnyCancellable? = nil
    private var appConfig = AppConfiguration()
    @Published var detectionStates: [(SoundIdentifier, DetectionState)] = []
    @Published var soundDetectionIsRunning: Bool = false 

    
    func restartDetection(config: AppConfiguration) {
        
        SystemAudioClassifier.singleton.stopSoundClassification()

        let classificationSubject = PassthroughSubject<SNClassificationResult, Error>()

        detectionCancellable =
          classificationSubject
          .receive(on: DispatchQueue.main)
          .sink(receiveCompletion: { _ in self.soundDetectionIsRunning = false },
                receiveValue: {
                    self.detectionStates = AppState.advanceDetectionStates(self.detectionStates, givenClassificationResult: $0)
                })
        
        self.detectionStates =
          [SoundIdentifier](config.monitoredSounds)
          .sorted(by: { $0.displayName < $1.displayName })
          .map { ($0, DetectionState(presenceThreshold: 0.2,
                                     absenceThreshold: 0.1,
                                     presenceMeasurementsToStartDetection: 2,
                                     absenceMeasurementsToEndDetection: 40))
          }
        soundDetectionIsRunning = true
        appConfig = config
        SystemAudioClassifier.singleton.startSoundClassification(
          subject: classificationSubject,
          inferenceWindowSize: config.inferenceWindowSize,
          overlapFactor: config.overlapFactor)
    }
    
    static func advanceDetectionStates(_ oldStates: [(SoundIdentifier, DetectionState)],
                                       givenClassificationResult result: SNClassificationResult) -> [(SoundIdentifier, DetectionState)] {
        
        let confidenceForLabel = { (sound: SoundIdentifier) -> Double in
            
            let confidence: Double
            let label = sound.labelName
        
            if let classification = result.classification(forIdentifier: label) {
                confidence = classification.confidence
            } else {
                confidence = 0
            }
            return confidence
        }
        
        return oldStates.map { (key, value) in
            (key, DetectionState(advancedFrom: value, currentConfidence: confidenceForLabel(key)))
        }
    }
}
