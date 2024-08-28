//
//  BandSettingView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct BandSettingView: View {
    @EnvironmentObject var audioManager: AudioManager
    @StateObject var songViewModel = SongViewModel()
    
    @State var isShowingMicrophoneSelector = false
    @State private var isAddingPresented = false
    @State private var isEditingPresented = false
    
    @StateObject var appState = AppState()
    @State var appConfig = AppConfiguration()
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                SideBarView(songViewModel: songViewModel, isAddingPresented: $isAddingPresented, isEditingPresented: $isEditingPresented, appState: appState, appConfig: $appConfig, path: $path)
                
                Spacer()
                
                if let selectedSong = songViewModel.selectedSong {
                    ForEach(selectedSong.instruments.sorted { $0.type.order < $1.type.order }) { instrument in
                        InstrumentReady(instrument: instrument.type)
                    }
                } else {
                    Text("곡을 추가해주세요.")
                        .font(.system(size: 23).bold())
                        .foregroundStyle(.white)
                }
                Spacer()
            }
            .navigationDestination(for: String.self) { string in
                if string == "playView" {
                    DetectSoundsView(state: appState, config: $appConfig, path: $path)
                }
            }
        }
        .padding(EdgeInsets(top: 50, leading: 20, bottom: 80, trailing: 64))
        .frame(minWidth: 1510, minHeight: 834)
        .sheet(isPresented: $isShowingMicrophoneSelector, content: {
            MicSelectView(isShowingMicrophoneSelector: $isShowingMicrophoneSelector)
        })
        .sheet(isPresented: $isEditingPresented, content: {
            InstrumentAddingView(songViewModel: songViewModel, isSheetPresented: $isEditingPresented, isEdit: true)
        })
        .sheet(isPresented: $isAddingPresented, content: {
            InstrumentAddingView(songViewModel: songViewModel, isSheetPresented: $isAddingPresented)
        })
        .onAppear {
            isShowingMicrophoneSelector = true
            Task {
                await audioManager.start()
            }
        }
    }
}
