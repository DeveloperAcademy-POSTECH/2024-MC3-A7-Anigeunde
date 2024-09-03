//
//  InstrumentSelectButton.swift
//  Lvlance
//
//  Created by 지영 on 7/31/24.
//

import SwiftUI

struct InstrumentSelectButton: View {
    
    @State private var isSelected = false
    @Binding var selectedInstruments: Set<InstrumentType>
    
    let instrumentType: InstrumentType

    var body: some View {
        VStack {
            Image("select_\(instrumentType.rawValue)")
                .onTapGesture {
                    isSelected.toggle()
                }
            
            HStack {
                Toggle("\(instrumentType.title)", isOn: $isSelected)
                    .toggleStyle(.checkbox)
                    .onChange(of: isSelected) {
                        if isSelected {
                            selectedInstruments.insert(instrumentType)
                        } else {
                            selectedInstruments.remove(instrumentType)
                        }
                    }
            }
        }
        .onAppear {
            if selectedInstruments.contains(instrumentType) {
                isSelected = true
            }
        }
    }
}


