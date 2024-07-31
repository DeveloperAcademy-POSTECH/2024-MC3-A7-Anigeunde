//
//  SideBarView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct playButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24))
            .foregroundStyle(.white)
            .background(.clear)
    }
}

struct SideBarView: View {
    @State private var isSectionExpanded = true
    var body: some View {
        VStack(alignment: .trailing ,spacing: 0) {
            Spacer().frame(height: 46)
            
            Button {
                print("재생버튼")
            } label: {
                Image(systemName: "play.fill")
            }
            .buttonStyle(playButtonStyle())
            .help("재생 버튼을 눌러 연주를 시작하세요")
            
            Spacer().frame(height: 20)
            
            Divider()
            
            List {
                Section("곡 선택하기", isExpanded: $isSectionExpanded) {
                    Label("새로운 노래", systemImage: "music.note")
                        .tint(.purple)
                }
            }
            .listStyle(SidebarListStyle())
            .frame(minHeight: 28, maxHeight: 449)
            .contextMenu(ContextMenu(menuItems: {
                Text("곡명 변경하기")
                Text("곡 삭제하기")
            }))
            
            Spacer().frame(height: 30)
            
            Button {
                print("곡 추가하기")
            } label: {
                Text("곡 추가하기")
                    .padding(.horizontal, 68)
            }
            
            Spacer()
                .frame(height: 136)
            
            Button {
                print("악기 편집하기")
            } label: {
                Text("악기 편집하기")
            }
            .padding(.trailing, 8)
        }
        .padding(12)
        .frame(width: 236, height: 712)
    }
}

#Preview {
    SideBarView()
}
