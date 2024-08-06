//
//  SideBarView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct SideBarView: View {
    @EnvironmentObject var coreDataManager: CoreDataManager
//    @Environment(\.openWindow) private var openWindow
    @State private var isSectionExpanded = true
    

    
    @Binding var songs: [Song]
    @Binding var selectedSong: Song?
    @Binding var isSheetPresented: Bool
    
    @ObservedObject var appState: AppState
    @Binding var appConfig: AppConfiguration
    @Binding var path: NavigationPath
    
    
    var body: some View {
        VStack(alignment: .trailing ,spacing: 0) {
            Spacer().frame(height: 46)
            
            Button {
                /// 선택된 노래의 악기 정보를 재생할 뷰에 넘겨주기
                guard let selectedSong = selectedSong else { return }
                appConfig.monitoredSounds = Set(selectedSong.instruments.map {
                    SoundIdentifier(instrument: $0.type)
                })
                /// 재생시키기
                appState.restartDetection(config: appConfig)
                path.append("playView")
            } label: {
                Image(systemName: "play.fill")
            }
            .buttonStyle(playButtonStyle())
            .help("재생 버튼을 눌러 연주를 시작하세요")
            
            Spacer().frame(height: 20)
            
            Divider()
                .foregroundStyle(.sidebarDivider)
            
            List {
                Section(isExpanded: $isSectionExpanded) {
                    ForEach(songs) { song in
                        Label {
                            Text(song.title)
                        } icon: {
                            Image(systemName: "music.note")
                                .foregroundStyle(.systemPurple)
                        }
                        .listRowBackground(Color.sidebarFrameBackground)
                        .onTapGesture {
                            selectedSong = song
                        }
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
            .contextMenu(ContextMenu(menuItems: {
                //TODO: update, delete
                Text("곡명 변경하기")
                Text("곡 삭제하기")
            }))
            
            Spacer().frame(height: 30)
            
            Button {
                ///새 노래 만들기
                
                
            } label: {
                Text("곡 추가하기")
                    .padding(.horizontal, 68)
            }
            .buttonStyle(.borderedProminent)
            
            
            
            Spacer()
                .frame(height: 136)
            
            //TODO: 버튼 바꾸기
            Button {
                isSheetPresented = true
            } label: {
                Text("악기 편집하기")
            }
            .buttonStyle(.borderedProminent)
            .padding(.trailing, 8)

        }
        .padding(12)
        .frame(width: 236, height: 712)
        .background(.sidebarBackground)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(AngularGradient(gradient: Gradient(colors: [.gradientBlue, .gradientPurple]), center: .center), lineWidth: 1)
        )
        .onAppear {
//            songs = coreDataManager.getAllSongs()
        }
    }
}

//#Preview {
//    SideBarView()
//        .environment(\.managedObjectContext, CoreDataManager.persistentContainer.viewContext)
//}
