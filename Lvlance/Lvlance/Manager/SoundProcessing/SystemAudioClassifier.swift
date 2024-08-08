//
//  SystemAudioClassifier.swift
//  Lvlance
//
//  Created by 이종선 on 7/29/24.
//

import Foundation
import AVFoundation
import SoundAnalysis
import Combine

final class SystemAudioClassifier: NSObject {
    
    enum SystemAudioClassificationError: Error {
        case audioStreamInterrupted
        case noAudioDeviceAvailable
    }

    private let analysisQueue = DispatchQueue(label:"classifying-sounds.AnalysisQueue")
    private var audioEngine: AVAudioEngine?
    private var analyzer: SNAudioStreamAnalyzer?
    private var retainedObservers: [SNResultsObserving]?
    private var subject: PassthroughSubject<SNClassificationResult, Error>?
    
    private override init() {}
    static let singleton = SystemAudioClassifier()
    
    func startSoundClassification(subject: PassthroughSubject<SNClassificationResult, Error>,
                                  inferenceWindowSize: Double,
                                  overlapFactor: Double) {
        stopSoundClassification()

        do {
            let observer = ClassificationResultsSubject(subject: subject)

            let request = try SNClassifySoundRequest(classifierIdentifier: .version1)
            request.windowDuration = CMTimeMakeWithSeconds(inferenceWindowSize, preferredTimescale: 48_000)
            request.overlapFactor = overlapFactor

            self.subject = subject
            try startAnalyzing([(request, observer)])
            
        } catch {
            subject.send(completion: .failure(error))
            self.subject = nil
            stopSoundClassification()
        }
    }

    func stopSoundClassification() {
        stopAnalyzing()
    }

    private func startAnalyzing(_ requestsAndObservers: [(SNRequest, SNResultsObserving)]) throws {
        stopAnalyzing()

        do {
                
            let newAudioEngine = AVAudioEngine()
            audioEngine = newAudioEngine

            let busIndex = AVAudioNodeBus(0)
            let bufferSize = AVAudioFrameCount(4096)
            let audioFormat = newAudioEngine.inputNode.outputFormat(forBus: busIndex)
            

            let newAnalyzer = SNAudioStreamAnalyzer(format: audioFormat)
            analyzer = newAnalyzer

            try requestsAndObservers.forEach { try newAnalyzer.add($0.0, withObserver: $0.1) }
            retainedObservers = requestsAndObservers.map { $0.1}
            
            newAudioEngine.inputNode.installTap(
              onBus: busIndex,
              bufferSize: bufferSize,
              format: audioFormat,
              block: { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
                  self.analysisQueue.async {
                      newAnalyzer.analyze(buffer, atAudioFramePosition: when.sampleTime)
                  }
              })

            try newAudioEngine.start()

        } catch {
            stopAnalyzing()
            throw error
        }
    }

    private func stopAnalyzing() {
        autoreleasepool {
            if let audioEngine = audioEngine {
                audioEngine.stop()
                audioEngine.inputNode.removeTap(onBus: 0)
            }

            if let analyzer = analyzer {
                analyzer.removeAllRequests()
            }

            analyzer = nil
            retainedObservers = nil
            audioEngine = nil
        }
    }

}

