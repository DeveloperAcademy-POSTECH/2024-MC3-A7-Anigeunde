//
//  BandSettingView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct BandSettingView: View {
    @StateObject var songViewModel = SongViewModel()
    
    @State private var isAddingPresented = false
    @State private var isEditingPresented = false
    
    @StateObject var appState = AppState()
    @State var appConfig = AppConfiguration()
    @State var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                SideBarView(songViewModel: songViewModel, isAddingPresented: $isAddingPresented, isEditingPresented: $isEditingPresented, appState: appState, appConfig: $appConfig, path: $path)
                    .padding(.leading, 20)
                
                Spacer()
                
                if let selectedSong = songViewModel.selectedSong {
                    ForEach(selectedSong.instruments) { instrument in
                        InstrumentReady(instrument: instrument)
                    }
                } else {
                    Text("곡을 추가해주세요.")
                        .font(.system(size: 23).bold())
                        .foregroundStyle(.white)
                        .padding(.horizontal, 500)
                }
                Spacer()
            }
            .navigationDestination(for: String.self) { string in
                if string == "playView" {
                    DetectSoundsView(state: appState, config: $appConfig, path: $path)
                }
            }
        }
        .frame(width: 1510, height: 834)
        .sheet(isPresented: $isEditingPresented, content: {
            InstrumentAddingView(songViewModel: songViewModel, isSheetPresented: $isEditingPresented, isEdit: true)
        })
        .sheet(isPresented: $isAddingPresented, content: {
            InstrumentAddingView(songViewModel: songViewModel, isSheetPresented: $isAddingPresented)
        })
        
    }
}
