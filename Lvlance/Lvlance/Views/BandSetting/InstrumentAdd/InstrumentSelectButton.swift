//
//  InstrumentSelectButton.swift
//  Lvlance
//
//  Created by 지영 on 7/31/24.
//

import SwiftUI

struct InstrumentSelectButton: View {
    @State private var isSelected = true
    var body: some View {
        VStack {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: 83, height: 83)
                    .foregroundStyle(.sidebarBackground)
                    
                Image("select_bass_guitar")
            }
                
            HStack {
                Toggle("보컬", isOn: $isSelected)
                    .toggleStyle(.checkbox)
            }
            
        }
    }
}

#Preview {
    InstrumentSelectButton()
}
