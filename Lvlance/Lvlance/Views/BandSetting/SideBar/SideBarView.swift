//
//  SideBarView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct SideBarView: View {
    @ObservedObject var songViewModel: SongViewModel
    
    @State private var isSectionExpanded = true
    @Binding var isAddingPresented: Bool
    @Binding var isEditingPresented: Bool
    
    @ObservedObject var appState: AppState
    @Binding var appConfig: AppConfiguration
    @Binding var path: NavigationPath
    
    @State private var editingSongId: UUID?
    @State private var editingTitle: String = ""
    
    private var isNoSongSelected: Bool {
            songViewModel.selectedSong == nil
        }
    
    private func requestMicrophonePermission() {
        MicrophonePermissionManager.shared.requestMicrophonePermission { granted in
            if granted {
                self.startPlaying()
            } else {
                MicrophonePermissionManager.shared.showMicrophoneAccessAlert()
            }
        }
    }
    private func startPlaying(){
        /// 선택된 노래의 악기 정보를 재생할 뷰에 넘겨주기
        guard let selectedSong = songViewModel.selectedSong else { return }
        
        appConfig.monitoredSounds = Set(selectedSong.instruments.map {
            SoundIdentifier(instrument: $0.type)
        })
        
        appState.restartDetection(config: appConfig) // 재생시키기
        path.append("playView")
    }
    
    var body: some View {
        VStack(alignment: .trailing ,spacing: 0) {
            Spacer().frame(height: 46)
            
            Button {
                
                MicrophonePermissionManager.shared.checkMicrophonePermission { status in
                    switch status {
                    case .notDetermined:
                        self.requestMicrophonePermission()
                    case .granted:
                        self.startPlaying()
                    case .denied:
                        MicrophonePermissionManager.shared.showMicrophoneAccessAlert()
                    }
                }
                
            } label: {
                if isNoSongSelected {
                    Image(systemName: "play.fill")
                        .foregroundStyle(.gray)
                } else {
                    Image(systemName: "play.fill")
                }
            }
            .help("재생 버튼을 눌러 연주를 시작하세요")
            .buttonStyle(playButtonStyle()) 
            .disabled(isNoSongSelected)
            
            Spacer().frame(height: 20)
            
            Divider()
                .foregroundStyle(.sidebarDivider)
            
            List {
                Section(isExpanded: $isSectionExpanded) {
                    ForEach(songViewModel.songs) { song in
                        Group {
                            if editingSongId == song.id {
                                TextField("곡 제목", text: $editingTitle)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .submitLabel(.done)
                                    .onSubmit {
                                        saveSongTitle(song: song)
                                    }
                            } else {
                                Label {
                                    Text(song.title)
                                } icon: {
                                    if song.id == songViewModel.selectedSong?.id {
                                        Image(systemName: "checkmark")
                                            .foregroundStyle(Color.white)
                                    } else {
                                        Image(systemName: "music.note")
                                            .foregroundStyle(.systemPurple)
                                    }
                                }
                            }
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
    
                            if editingSongId == song.id {
                                saveSongTitle(song: song)
                            } else {
                                selectSong(song)
                            }
                            
                        }
                        .contextMenu{
                            Button("악기 편집하기") {
                                songViewModel.editingSong = song
                                isEditingPresented = true
                            }
                            
                            Button("곡명 변경하기") {
                                editingSongId = song.id
                                editingTitle = song.title
                            }
                            Button("곡 삭제하기") {
                                songViewModel.deleteSong(song: song)
                            }
                        }
                        .listRowBackground(song.id == songViewModel.selectedSong?.id ? Color.accentColor.opacity(0.6) : Color.sidebarFrameBackground)
                    }
                } header: {
                    Text("곡 선택하기")
                        .foregroundStyle(.white)
                        .padding(.bottom, 7)
                }
            }
            .background(
                Color.clear
                    .contentShape(Rectangle())
                    .onTapGesture {
                        cancelEditing()
                    }
            )
            .scrollContentBackground(.hidden)
            .listStyle(SidebarListStyle())
            .frame(minHeight: 28, maxHeight: 449)
            
            Spacer().frame(height: 30)
            
            Button {
                isAddingPresented = true
            } label: {
                Text("곡 추가하기")
                    .frame(width: 212, height: 24)
                    .foregroundStyle(.white)
            }
            .buttonStyle(sideBarButtonStyle())
            
            Spacer().frame(height: 136)
            
            
        }
        .padding(12)
        .frame(width: 236, height: 712)
        .background(.sidebarBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AngularGradient(gradient: Gradient(colors: [.gradientBlue, .gradientPurple]), center: .center), lineWidth: 1)
        )
        .shadow(color: .gradientPurple.opacity(0.2), radius: 10)
    }
    
    private func saveSongTitle(song: Song) {
        guard !editingTitle.isEmpty else {
            cancelEditing()
            return
        }
        
        if editingTitle != song.title {
            songViewModel.updateSongTitle(song: song, newTitle: editingTitle)
        }
        
        cancelEditing()
    }
    
    private func selectSong(_ song: Song) {
        if editingSongId != nil {
            cancelEditing()
        }
        songViewModel.selectedSong = song
    }
    
    private func cancelEditing() {
        editingSongId = nil
        editingTitle = ""
    }
}

