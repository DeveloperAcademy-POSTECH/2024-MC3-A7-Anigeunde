//
//  InstrumentAddingView.swift
//  Lvlance
//
//  Created by 지영 on 7/31/24.
//

import SwiftUI

struct InstrumentAddingView: View {
    
    @ObservedObject var songViewModel: SongViewModel
    
    @State var selectedInstrumentsType: Set<InstrumentType> = []
    @Binding var isSheetPresented: Bool
    
    var isEdit: Bool = false
    
    var body: some View {
        VStack {
            Text("이 곡에서 연주할 악기를 선택해주세요.")
                .font(.system(size: 13).bold())
                .padding(.vertical, 32)
            HStack {
                ForEach(InstrumentType.allCases, id: \.self) { instrumentType in
                    InstrumentSelectButton(selectedInstruments: $selectedInstrumentsType, instrumentType: instrumentType)
                }
            }
            .padding(.horizontal, 40)
            
            Spacer().frame(height: 42)
            
            HStack {
                Spacer()
                
                Button {
                    isSheetPresented = false
                } label: {
                    Text("취소")
                        .frame(width: 38.5, height: 20)
                        .cornerRadius(6)
                }
                .frame(width: 38.5, height: 20)
                .cornerRadius(6)
                
                Button {
                    if isEdit {
                        if let selectedSong = songViewModel.selectedSong {
                            songViewModel.updateInstrument(song: selectedSong, selectedInstruments: selectedInstrumentsType.map{ Instrument(type: $0) })
                        }
                    } else {
                        songViewModel.createSong(selectedInstruments: selectedInstrumentsType.map { Instrument(type: $0) })
                        songViewModel.setupSongs()
                    }
                    isSheetPresented = false
                } label: {
                    Text("선택")
                        .frame(width: 38, height: 20)
                        .background(Color.accentColor)
                        .cornerRadius(6)
                }
                .frame(width: 38.5, height: 20)
                .cornerRadius(6)
            }
            .padding([.trailing, .bottom], 20)
        }
        .onAppear {
            if isEdit {
                if let selectedSong = songViewModel.selectedSong {
                    selectedInstrumentsType = Set(selectedSong.instruments.map { $0.type })
                }
            }
        }
    }
}
