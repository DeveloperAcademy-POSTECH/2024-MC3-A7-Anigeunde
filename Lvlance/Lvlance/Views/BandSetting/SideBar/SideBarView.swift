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
    
    var body: some View {
        VStack(alignment: .trailing ,spacing: 0) {
            Spacer().frame(height: 46)
            
            Button {
                /// 선택된 노래의 악기 정보를 재생할 뷰에 넘겨주기
                guard let selectedSong = songViewModel.selectedSong else { return }
                
                appConfig.monitoredSounds = Set(selectedSong.instruments.map {
                    SoundIdentifier(instrument: $0.type)
                })
                
                appState.restartDetection(config: appConfig) // 재생시키기
                path.append("playView")
            } label: {
                Image(systemName: "play.fill")
            }
            .help("재생 버튼을 눌러 연주를 시작하세요")
            .buttonStyle(playButtonStyle())            
            
            Spacer().frame(height: 20)
            
            Divider()
                .foregroundStyle(.sidebarDivider)
            
            List {
                Section(isExpanded: $isSectionExpanded) {
                    ForEach(songViewModel.songs) { song in
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
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            songViewModel.selectedSong = song
                        }
                        .listRowBackground(song.id == songViewModel.selectedSong?.id ? Color.accentColor.opacity(0.6) : Color.sidebarFrameBackground)
                    }
                } header: {
                    Text("곡 선택하기")
                        .foregroundStyle(.white)
                        .padding(.bottom, 7)
                }
            }
            .scrollContentBackground(.hidden)
            .listStyle(SidebarListStyle())
            .frame(minHeight: 28, maxHeight: 449)
            .contextMenu{
                Button("곡명 변경하기") {
                   //TODO: 곡명 변경 만들기
                }
                Button("곡 삭제하기") {
                    if let selectedSong = songViewModel.selectedSong {
                        songViewModel.deleteSong(song: selectedSong)
                    }
                }
            }
            
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
            
            Button {
                isEditingPresented = true
            } label: {
                Text("악기 편집하기")
                    .frame(width: 92, height: 24)
                
            }
            .buttonStyle(sideBarButtonStyle())
            
            
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
}

