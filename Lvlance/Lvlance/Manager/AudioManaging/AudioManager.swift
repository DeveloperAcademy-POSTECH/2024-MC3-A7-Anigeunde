//
//  AudioManager.swift
//  Lvlance
//
//  Created by 이종선 on 7/30/24.
//


import Combine
import Foundation
import CoreAudio
import AVFoundation

@MainActor
class AudioManager: NSObject, ObservableObject {
    
    enum Error: Swift.Error {
        case noAudioDeviceAvailable
        case setupFailed
    }
    
    enum State: @unchecked Sendable {
        case unknown
        case unauthorized
        case failed
        case running
        case stopped
    }
    
    @Published private(set) var state = State.unknown
    @Published private(set) var audioDevices = [Device]()
    @Published var selectedAudioDevice = Device.invalid
    @Published var isSelectedDeviceAvailable = true
    @Published var showDisconnectionAlert = false
    @Published var disconnectedDeviceName = ""
    
    private var subscriptions = Set<AnyCancellable>()
    private let propertyListenerProc: AudioObjectPropertyListenerProc
    
    override init() {
        self.propertyListenerProc = { inObjectID, inNumberAddresses, inAddresses, inClientData in
            let audioManager = Unmanaged<AudioManager>.fromOpaque(inClientData!).takeUnretainedValue()
            Task { @MainActor in
                await audioManager.handleDeviceChange()
            }
            return noErr
        }
        
        super.init()
        
        $selectedAudioDevice
            .dropFirst().removeDuplicates()
            .sink { [weak self] device in
                self?.selectDevice(device)
            }.store(in: &subscriptions)
        
        setupDeviceChangeListener()
    }
    
    func start() async {
        do {
            try setup()
            state = .running
        } catch {
            state = .failed
        }
    }
    
    private func setup() throws {
        updateAudioDevices()
        
        if let defaultDevice = audioDevices.first {
            selectedAudioDevice = defaultDevice
        }
    }
    
    private func updateAudioDevices() {
        
        assert(Thread.isMainThread, "updateAudioDevices must be called on the main thread")
        
        var propertySize: UInt32 = 0
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var status = AudioObjectGetPropertyDataSize(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propertySize)
        
        guard status == noErr else {
            print("Error getting property size: \(status)")
            return
        }
        
        let deviceCount = Int(propertySize) / MemoryLayout<AudioObjectID>.size
        var deviceIDs = [AudioObjectID](repeating: 0, count: deviceCount)
        
        status = AudioObjectGetPropertyData(AudioObjectID(kAudioObjectSystemObject), &address, 0, nil, &propertySize, &deviceIDs)
        
        guard status == noErr else {
            print("Error getting device IDs: \(status)")
            return
        }
        
        audioDevices = deviceIDs.compactMap { deviceID in
            if hasInputChannels(deviceID: deviceID) {
                let name = getDeviceName(deviceID: deviceID)
                let (hasControl, currentGain, minGain, maxGain) = checkGainControl(for: Device(id: String(deviceID), name: name, hasGainControl: false, currentGain: 0, minGain: 0, maxGain: 1))
                return Device(id: String(deviceID), name: name, hasGainControl: hasControl, currentGain: currentGain, minGain: minGain, maxGain: maxGain)
            }
            return nil
        }
        
        print("Found \(audioDevices.count) audio input devices")
        audioDevices.forEach { print($0) }
    }
    
    private func hasInputChannels(deviceID: AudioObjectID) -> Bool {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyStreamConfiguration,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var propertySize: UInt32 = 0
        var status = AudioObjectGetPropertyDataSize(deviceID, &address, 0, nil, &propertySize)
        
        guard status == noErr else {
            print("Error getting stream configuration size: \(status)")
            return false
        }
        
        let bufferList = UnsafeMutablePointer<AudioBufferList>.allocate(capacity: Int(propertySize))
        defer { bufferList.deallocate() }
        
        status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &propertySize, bufferList)
        
        guard status == noErr else {
            print("Error getting stream configuration: \(status)")
            return false
        }
        
        let bufferListPtr = UnsafeMutableAudioBufferListPointer(bufferList)
        
        for bufferPtr in bufferListPtr {
            if bufferPtr.mNumberChannels > 0 {
                return true
            }
        }
        
        return false
    }
    
    private func getDeviceName(deviceID: AudioObjectID) -> String {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioObjectPropertyName,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var propertySize = UInt32(MemoryLayout<CFString>.size)
        var result: Unmanaged<CFString>?
        
        let status = AudioObjectGetPropertyData(
            deviceID,
            &address,
            0,
            nil,
            &propertySize,
            &result
        )
        
        if status != noErr {
            print("Error getting device name: \(status)")
            return "Unknown Device"
        }
        
        guard let resultUnwrapped = result else {
            return "Unknown Device"
        }
        
        let name = resultUnwrapped.takeRetainedValue() as String
        return name
    }
    
    func selectDevice(_ device: Device) {
        guard var deviceID = AudioObjectID(device.id) else { return }
        
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDefaultInputDevice,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        
        let status = AudioObjectSetPropertyData(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            0,
            nil,
            UInt32(MemoryLayout<AudioObjectID>.size),
            &deviceID
        )
        
        if status == noErr {
            selectedAudioDevice = device
            print("오디오 입력 장치가 성공적으로 변경되었습니다: \(device.name)")
        } else {
            print("오디오 입력 장치 변경 실패: \(status)")
        }
    }
    
    private func setupDeviceChangeListener() {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )

        let selfPtr = Unmanaged.passUnretained(self).toOpaque()

        let status = AudioObjectAddPropertyListener(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            self.propertyListenerProc,
            selfPtr
        )

        if status != noErr {
            print("Failed to add property listener: \(status)")
        }
    }

    private func handleDeviceChange() async {
        updateAudioDevices()
        checkSelectedDeviceAvailability()
    }

    private func checkSelectedDeviceAvailability() {
        guard selectedAudioDevice.id != Device.invalid.id else { return }
        
        let isAvailable = audioDevices.contains { $0.id == selectedAudioDevice.id }
        if isSelectedDeviceAvailable && !isAvailable {
            showDeviceDisconnectedAlert()
        }
        isSelectedDeviceAvailable = isAvailable
    }

    private func showDeviceDisconnectedAlert() {
        disconnectedDeviceName = selectedAudioDevice.name
        showDisconnectionAlert = true
        print("경고: 선택된 오디오 장치 '\(selectedAudioDevice.name)'가 연결 해제되었습니다.")
        
        if let defaultDevice = audioDevices.first {
            selectDevice(defaultDevice)
        } else {
            selectedAudioDevice = Device.invalid
        }
    }
    
    func checkGainControl(for device: Device) -> (hasControl: Bool, currentGain: Float, minGain: Float, maxGain: Float) {
        guard let deviceID = AudioObjectID(device.id) else {
            return (false, 0, 0, 0)
        }
        
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var hasControl: DarwinBoolean = false
        let propertyExists = AudioObjectHasProperty(deviceID, &address)
        
        if propertyExists {
            let status = AudioObjectIsPropertySettable(deviceID, &address, &hasControl)
            if status != noErr || !hasControl.boolValue {
                return (false, 0, 0, 0)
            }
        } else {
            return (false, 0, 0, 0)
        }
        
        var gain: Float = 0
        var size = UInt32(MemoryLayout<Float>.size)
        var status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &gain)
        
        if status != noErr {
            return (true, 0, 0, 1)
        }
        
        address.mSelector = kAudioDevicePropertyVolumeScalarToDecibels
        var minGain: Float = -60  // 일반적인 최소값
        status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &minGain)
        
        address.mSelector = kAudioDevicePropertyVolumeDecibelsToScalar
        var maxGain: Float = 20  // 일반적인 최대값
        status = AudioObjectGetPropertyData(deviceID, &address, 0, nil, &size, &maxGain)
        
        return (true, gain, minGain, maxGain)
    }
    
    func setGain(_ gain: Float, for device: Device) {
        guard let deviceID = AudioObjectID(device.id) else { return }
        
        let clampedGain = max(device.minGain, min(gain, device.maxGain))
        
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioDevicePropertyVolumeScalar,
            mScope: kAudioDevicePropertyScopeInput,
            mElement: kAudioObjectPropertyElementMain
        )
        
        var newGain = clampedGain
        let status = AudioObjectSetPropertyData(
            deviceID,
            &address,
            0,
            nil,
            UInt32(MemoryLayout<Float>.size),
            &newGain
        )
        
        if status == noErr {
            if let index = audioDevices.firstIndex(where: { $0.id == device.id }) {
                audioDevices[index].currentGain = clampedGain
            }
            print("Gain for device '\(device.name)' set to \(clampedGain)")
        } else {
            print("Failed to set gain for device '\(device.name)': \(status)")
        }
    }
    
    deinit {
        var address = AudioObjectPropertyAddress(
            mSelector: kAudioHardwarePropertyDevices,
            mScope: kAudioObjectPropertyScopeGlobal,
            mElement: kAudioObjectPropertyElementMain
        )
        AudioObjectRemovePropertyListener(
            AudioObjectID(kAudioObjectSystemObject),
            &address,
            self.propertyListenerProc,
            Unmanaged.passUnretained(self).toOpaque()
        )
    }
}
