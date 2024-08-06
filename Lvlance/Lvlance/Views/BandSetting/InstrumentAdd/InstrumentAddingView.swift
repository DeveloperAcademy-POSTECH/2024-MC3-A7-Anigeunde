//
//  InstrumentAddingView.swift
//  Lvlance
//
//  Created by 지영 on 7/31/24.
//

import SwiftUI

struct InstrumentAddingView: View {
    @EnvironmentObject var coreDataManager: CoreDataManager

    @Binding private var isSheetPresented: Bool
    @Binding var selectedInstruments: Set<InstrumentType>
    
    var body: some View {
        VStack {
            Text("이 곡에서 연주할 악기를 선택해주세요.")
                .font(.system(size: 13).bold())
                .padding(.vertical, 32)
            HStack {
                ForEach(InstrumentType.allCases, id: \.self) { instrumentType in                    
                    VStack {
                        InstrumentSelectButton(selectedInstruments: $selectedInstruments, instrumentType: instrumentType)
                    }
                }
            }
            
            Spacer()
                .frame(height: 42)
            
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
                    ///1. song 만들고,
                    ///2. 거기에 선택된 instrument 추가
                    ///3. song 저장
                    ///4. bandsettingview에 넘겨주기
                    
                    print(selectedInstruments)
                    //createsong
                    
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
    }
}
