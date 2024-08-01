//
//  BandSettingView.swift
//  Lvlance
//
//  Created by 지영 on 7/22/24.
//

import SwiftUI

struct BandSettingView: View {
    var body: some View {
        HStack {
            SideBarView()
            
            ForEach(0...4, id: \.self) { _ in
                InstrumentReady()
            }
            .padding()
        }
        .frame(width: 1510, height: 834)

    }
}

#Preview {
    BandSettingView()
}
