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
        alert.messageText = "마이크 접근 권한 필요"
        alert.informativeText = "이 기능을 사용하려면 마이크 접근 권한이 필요합니다. 시스템 설정에서 권한을 허용해주세요."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "설정으로 이동")
        alert.addButton(withTitle: "취소")
        
        let response = alert.runModal()
        if response == .alertFirstButtonReturn {
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone") {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
