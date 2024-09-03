//
//  InstrumentBar.swift
//  Lvlance
//
//  Created by 이종선 on 7/30/24.
//

import SwiftUI
struct InstrumentBar: View {
    
    @Binding var confidence: Double
    let instrument: InstrumentType
    
    var body: some View {
        ZStack {
            VStack(spacing: 92) {
                Text(instrument.title)
                    .font(.system(size: 22))
                    .background{
                        if(confidence == 0){
                            Image("xmark")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 227, height: 200)  
                        }
                    }
                
                ZStack {
                    Rectangle()
                        .fill(.black)
                        .frame(width: 200, height: 569)
                        .overlay{
                            DetectSoundsView
                                .generateMeter(confidence: confidence, width: 200, height: 569,varientSize: instrument.varientSize)
                        }
                        .mask(
                            Image(instrument.maskImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        )
                        .overlay{
                            Image(instrument.outlineImage)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                }
            }
        }
    }
}
