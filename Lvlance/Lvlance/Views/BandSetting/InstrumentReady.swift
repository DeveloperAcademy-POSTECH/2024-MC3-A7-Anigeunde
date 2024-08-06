//
//  InstrumentReady.swift
//  Lvlance
//
//  Created by 지영 on 8/1/24.
//

import SwiftUI

struct InstrumentReady: View {    
    let instrument: Instrument
    
    var body: some View {
        VStack {
            Text(instrument.type.rawValue)
            
            Spacer().frame(height: 92)
            
            Image(instrument.type.outlineImage)
                .opacity(0.4)
        }
    }
}

