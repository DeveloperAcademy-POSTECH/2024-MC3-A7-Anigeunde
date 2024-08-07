//
//  AudioInputLevelManager.swift
//  Lvlance
//
//  Created by 이종선 on 8/2/24.
//

import SwiftUI
import Combine
import CoreAudio
import AudioToolbox

class AudioInputLevelManager: ObservableObject {
    
    @Published private(set) var currentAudioLevel: Float = 0.0
    private var audioQueue: AudioQueueRef?

    func startMonitoring() {
        stopMonitoring()
        
        var dataFormat = AudioStreamBasicDescription(
            mSampleRate: 44100.0,
            mFormatID: kAudioFormatLinearPCM,
            mFormatFlags: kLinearPCMFormatFlagIsSignedInteger | kLinearPCMFormatFlagIsPacked,
            mBytesPerPacket: 2,
            mFramesPerPacket: 1,
            mBytesPerFrame: 2,
            mChannelsPerFrame: 1,
            mBitsPerChannel: 16,
            mReserved: 0
        )
        
        var audioQueue: AudioQueueRef?
        var error = AudioQueueNewInput(
            &dataFormat,
            audioQueueInputCallback,
            Unmanaged.passUnretained(self).toOpaque(),
            nil,
            nil,
            0,
            &audioQueue
        )
        
        guard error == noErr, let queue = audioQueue else {
            print("Error creating audio queue: \(error)")
            return
        }
        
        self.audioQueue = queue
        
        var enabledLevelMeter: UInt32 = 1
        AudioQueueSetProperty(queue, kAudioQueueProperty_EnableLevelMetering, &enabledLevelMeter, UInt32(MemoryLayout<UInt32>.size))
        
        let bufferByteSize: UInt32 = 512
        
        for _ in 0..<3 {
            var buffer: AudioQueueBufferRef?
            error = AudioQueueAllocateBuffer(queue, bufferByteSize, &buffer)
            if let buffer = buffer {
                AudioQueueEnqueueBuffer(queue, buffer, 0, nil)
            }
        }
        
        error = AudioQueueStart(queue, nil)
        if error != noErr {
            print("Error starting audio queue: \(error)")
            return
        }
    }

    func stopMonitoring() {
        if let queue = audioQueue {
            AudioQueueStop(queue, true)
            AudioQueueDispose(queue, true)
            audioQueue = nil
        }
    }

    func updateAudioLevel() {
        guard let queue = audioQueue else { return }
        
        var levelMeter = AudioQueueLevelMeterState()
        var propertySize = UInt32(MemoryLayout<AudioQueueLevelMeterState>.size)
        
        let error = AudioQueueGetProperty(queue, kAudioQueueProperty_CurrentLevelMeterDB, &levelMeter, &propertySize)
        
        if error == noErr {
            let level = levelMeter.mAveragePower
            let normalizedLevel = (level + 50) / 50
            let clampedLevel = max(0, min(normalizedLevel, 1)) 
            DispatchQueue.main.async {
                self.currentAudioLevel = clampedLevel
            }
        } else {
            print("Error getting audio level: \(error)")
        }
    }

    deinit {
        stopMonitoring()
    }
}

func audioQueueInputCallback(
    _ inUserData: UnsafeMutableRawPointer?,
    _ inAQ: AudioQueueRef,
    _ inBuffer: AudioQueueBufferRef,
    _ inStartTime: UnsafePointer<AudioTimeStamp>,
    _ inNumberPacketDescriptions: UInt32,
    _ inPacketDescs: UnsafePointer<AudioStreamPacketDescription>?
) {
    guard let inUserData = inUserData else { return }
    let audioInputManager = Unmanaged<AudioInputLevelManager>.fromOpaque(inUserData).takeUnretainedValue()
    audioInputManager.updateAudioLevel()
    AudioQueueEnqueueBuffer(inAQ, inBuffer, 0, nil)
}
