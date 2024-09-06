//
//  SetupMonitoredSoundView.swift
//  Lvlance
//
//  Created by 이종선 on 7/30/24.
//
//import SwiftUI
//
//
//enum AppRoute: Hashable {
//    case detectSounds
//}
//
//// 여기서 이미 설정되어있는 값을 받아 수정 가능하게 해줌
//struct SetupMonitoredSoundsView: View {
//    
//    @ObservedObject var appState: AppState
//    @Binding var appConfig: AppConfiguration
//    
//    // 현재 설정 중인 변경사항을 저장
//    @State private var selectedInstruments: Set<InstrumentType> = []
//    @State private var navigationPath = NavigationPath()
//    
//    var body: some View {
//        NavigationStack(path: $navigationPath) {
//            VStack {
//                Text("탐지할 악기 선택").font(.title).padding()
//                
//                HStack {
//                    ForEach(InstrumentType.allCases, id: \.self) { instrument in
//                        Button(action: {
//                            toggleSelection(instrument)
//                        }) {
//                            VStack {
//                                Image(instrument.maskImage)
//                                    .resizable()
//                                    .scaledToFit()
//                                    .frame(width: 100, height: 100)
//                                Text(instrument.title)
//                                Spacer()
//                                if selectedInstruments.contains(instrument) {
//                                    Image(systemName: "checkmark.circle.fill")
//                                        .foregroundColor(.blue)
//                                } else {
//                                    Image(systemName: "circle")
//                                        .foregroundColor(.gray)
//                                }
//                            }
//                        }
//                    }
//                }
//                
//                Button(action: {
//                    updateSelectedSounds()
//                    appState.restartDetection(config: appConfig)
//                    navigationPath.append(AppRoute.detectSounds)
//                }) {
//                    Text("완료")
//                        .padding()
//                        .background(Color.blue)
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                }
//            }
//            .onAppear(perform: initializeSelectedInstruments)
//            .navigationDestination(for: AppRoute.self) { route in
//                switch route {
//                case .detectSounds:
//                 DetectSoundsView(state: appState, config: $appConfig, path: $navigationPath)
//                }
//            }
//        }
//    }
//    
//    private func toggleSelection(_ instrument: InstrumentType) {
//        if selectedInstruments.contains(instrument) {
//            selectedInstruments.remove(instrument)
//        } else {
//            selectedInstruments.insert(instrument)
//        }
//    }
//    
//    private func updateSelectedSounds() {
//        appConfig.monitoredSounds = Set(selectedInstruments.map { SoundIdentifier(instrument: $0) })
//    }
//    
//    private func initializeSelectedInstruments() {
//        selectedInstruments = Set(appConfig.monitoredSounds.map { $0.instrument })
//    }
//}
