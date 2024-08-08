//
//  InstrumentReady.swift
//  Lvlance
//
//  Created by 지영 on 8/1/24.
//

import SwiftUI

struct InstrumentReady: View {    
    let instrument: InstrumentType
    
    var body: some View {
        VStack {
            Text(instrument.rawValue)
                .font(.system(size: 22))
            
            Spacer().frame(height: 92)
            
            Image(instrument.outlineImage)
                .opacity(0.4)
        }
        .frame(width: 200, height: 569)
    }
}

