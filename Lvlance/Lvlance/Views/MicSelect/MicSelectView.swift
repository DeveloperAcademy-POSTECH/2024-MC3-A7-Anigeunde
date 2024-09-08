//
//  MicSelectView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct MicSelectView: View {
    
    @EnvironmentObject var audioManager: AudioManager
    @Binding var isShowingMicrophoneSelector : Bool
        
    var body: some View {
        VStack{
            Spacer().frame(height: 99)
            Text(audioManager.selectedAudioDevice == Device.invalid ? "밴드의 전체 소리를 입력할 기기를 선택해주세요. (권장 기기: iPhone)" : "선택하신 디바이스로 밴드의 연주 소리를 입력받습니다.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text(audioManager.selectedAudioDevice == Device.invalid ? "이 기기가 입력한 밴드의 소리는 악기별로 분류되어 앱 내에 반영됩니다." : "원하는 위치에 입력 기기를 놓아주세요.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .fontWeight(audioManager.selectedAudioDevice == Device.invalid ? .light : .bold )
            Spacer().frame(height: 38)
            
            
            Picker("", selection: $audioManager.selectedAudioDevice) {
                ForEach(audioManager.audioDevices, id: \.self) { device in
                    Text(device.name).tag(device)
                }
            }
            .labelsHidden()
            .padding([.leading, .bottom, .trailing], 0.0)
            .frame(width: 250)
            .pickerStyle(.menu)
            
            Spacer().frame(height: 25)
            
            Button(action: {
                //마이크 설정 저장
                isShowingMicrophoneSelector = false
            }) {
                Text("마이크 선택하기")
                    .multilineTextAlignment(.center)
                    .frame(width: 212, height: 24)
                    .cornerRadius(6)
                    .background(audioManager.selectedAudioDevice == .invalid ? .gray : .systemPurple)
                
            }
            .frame(width: 212, height: 24)
            .cornerRadius(6)
            .disabled(audioManager.selectedAudioDevice == .invalid)
            
            Spacer().frame(height: 80)
            

        }
        .tint(.systemPurple)
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .frame(width: 558, height: 364)
    }
}



#Preview {
    MicSelectView( isShowingMicrophoneSelector: .constant(true))
}
