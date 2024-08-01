//
//  MicSelectView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct MicSelectView: View {
    
    @StateObject private var audioManager = AudioManager()
    @State private var selectedDevice: Device = .invalid
    
        
    var body: some View {
        VStack{
            Spacer().frame(height: 99)
            Text(selectedDevice == Device.invalid ? "밴드의 전체 소리를 입력할 기기를 선택해주세요. (권장 기기: iPhone)" : "선택하신 디바이스가 밴드의 연주 소리를 입력합니다.")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
            
            Text(selectedDevice == Device.invalid ? "이 기기가 입력한 밴드의 소리는 악기별로 분류되어 앱 내에 반영됩니다." : "선택하신 디바이스가 밴드의 연주 소리를 입력합니다.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .fontWeight(selectedDevice == Device.invalid ? .light : .bold )
            Spacer().frame(height: 38)
            
            
            Picker("", selection: $selectedDevice) {
                ForEach(audioManager.audioDevices, id: \.self) { device in
                    Text(device.name).tag(device)
                }
            }
            .labelsHidden()
            .padding([.leading, .bottom, .trailing], 0.0)
            .frame(width: 212)
            .pickerStyle(.menu)
            
            Spacer().frame(height: 25)
            
            Button(action: {
                //마이크 설정 저장
            }) {
                Text("곡 선택하기")
                    .multilineTextAlignment(.center)
                    .frame(width: 212, height: 24)
                    .background(selectedDevice == Device.invalid ? Color.gray : Color.accentColor)
                    .cornerRadius(6)
                
            }
            .frame(width: 212, height: 24)
            .cornerRadius(6)
            
            Spacer().frame(height: 80)
            
            HStack{
                Button(action: {
                    print("건너뛰기")
                    //곡 선택 뷰 연결
                }) {
                    Text("건너뛰기")
                        .foregroundColor(.black)
                }
                .background(.white)
                .cornerRadius(6)
                .help("입력 기기 설정을 할 필요가 없는 경우, 건너뛰기하세요")

                Spacer()
            }
            .padding(.bottom, 17)
        }
        .shadow(radius: 10)
        .padding(.horizontal, 20)
        .frame(width: 558, height: 364)
    }
}



#Preview {
    MicSelectView()
}
