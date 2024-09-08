//
//  MicrophonePermissionManager.swift
//  Lvlance
//
//  Created by 이종선 on 9/8/24.
//
import AVFoundation
import AppKit

class MicrophonePermissionManager {
    static let shared = MicrophonePermissionManager()
    
    private init() {}
    
    enum MicrophonePermissionStatus {
        case notDetermined
        case granted
        case denied
    }
    
    func checkMicrophonePermission(completion: @escaping (MicrophonePermissionStatus) -> Void) {
        switch AVCaptureDevice.authorizationStatus(for: .audio) {
        case .notDetermined:
            completion(.notDetermined)
        case .authorized:
            completion(.granted)
        case .denied, .restricted:
            completion(.denied)
        @unknown default:
            completion(.notDetermined)
        }
    }
    
    func requestMicrophonePermission(completion: @escaping (Bool) -> Void) {
        AVCaptureDevice.requestAccess(for: .audio) { granted in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    func showMicrophoneAccessAlert() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("MicrophoneAccessRequired", comment: "Alert title for microphone access")
        alert.informativeText = NSLocalizedString("MicrophoneAccessDescription", comment: "Description for microphone access requirement")
        alert.alertStyle = .warning
        alert.addButton(withTitle: NSLocalizedString("GoToSettings", comment: "Button to open settings"))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: "Cancel button"))
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
