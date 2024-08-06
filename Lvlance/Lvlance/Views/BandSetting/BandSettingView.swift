//
//  BandSettingView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct BandSettingView: View {
    @EnvironmentObject var coreDataManager: CoreDataManager
    @StateObject var appState = AppState()
    @State var appConfig = AppConfiguration()
    @State var path = NavigationPath()
    @State var songs: [Song] = []
    @State var selectedSong: Song?
    @State private var isSheetPresented = false

    
    var body: some View {
        NavigationStack(path: $path) {
            HStack {
                SideBarView(songs: $songs, selectedSong: $selectedSong, isSheetPresented: $isSheetPresented, appState: appState, appConfig: $appConfig, path: $path)
                    .padding(.leading, 20)
                
                Spacer()
                if let selectedSong = selectedSong {
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

            
        }
        .frame(width: 1510, height: 834)

        .navigationDestination(for: String.self) { string in
            if string == "playView" {
                DetectSoundsView(state: appState, config: $appConfig, path: $path)
            }
        }
        
        .onAppear {
            songs = coreDataManager.getAllSongs()
            getSelectedSong()
            print(selectedSong)
        }
    }
    
    func getSelectedSong() {
        if !songs.isEmpty {
            selectedSong = songs.first
        }
    }
}
