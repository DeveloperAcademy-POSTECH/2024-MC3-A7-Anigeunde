//
//  SettingPopoverView.swift
//  Lvlance
//
//  Created by 이종선 on 8/1/24.
//

import SwiftUI

struct SettingPopoverView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var audioInputLevelManager = AudioInputLevelManager()
    
    @State private var inputLevel: Double = 0.5
    @State private var isExpanded = false
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 20) {
            Text("입력 레벨")
                .font(.headline)
            Text("전체 입력 레벨을 조절해보세요.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 2) {
                ForEach(0..<30, id: \.self) { index in
                    Rectangle()
                        .fill(Color.white.opacity(index < Int(audioInputLevelManager.currentAudioLevel * 30) ? 1.0 : 0.5))
                        .frame(width: 5, height: 20)
                }
            }
            
            Slider(value: $audioManager.selectedAudioDevice.currentGain, in: audioManager.selectedAudioDevice.minGain...audioManager.selectedAudioDevice.maxGain) { _ in
                audioManager.setGain(audioManager.selectedAudioDevice.currentGain, for: audioManager.selectedAudioDevice)
            }
            .accentColor(.white)
            .disabled(!audioManager.selectedAudioDevice.hasGainControl)
            
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    ScrollView {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(audioManager.audioDevices, id: \.id) { device in
                                Text(device.name)
                                    .foregroundColor(device.id == audioManager.selectedAudioDevice.id ? .systemPurple : .white)
                                    .onTapGesture {
                                        audioManager.selectDevice(device)
                                    }
                            }
                        }
                        .frame(maxHeight: 200) // 최대 높이 제한
                    }
                    .padding(.vertical, 5)
                },
                label: {
                    Text("입력 기기 선택하기")
                        .foregroundColor(.white)
                }
            )
            
        }
        .animation(.easeInOut, value: isExpanded)
        .padding()
        .foregroundColor(.white)
        .onAppear {
            audioInputLevelManager.startMonitoring()
        }
        .onDisappear {
            audioInputLevelManager.stopMonitoring()
        }
    }
}

#Preview {
    SettingPopoverView()
}
