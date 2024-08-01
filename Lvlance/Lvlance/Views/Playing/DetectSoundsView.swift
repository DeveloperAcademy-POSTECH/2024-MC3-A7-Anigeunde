//
//  DetectSoundsView.swift
//  Lvlance
//
//  Created by 이종선 on 7/30/24.
//


import Foundation
import SwiftUI

struct DetectSoundsView: View {
    
    @ObservedObject var state: AppState
    @Binding var config: AppConfiguration
    @Binding var path: NavigationPath
    @State private var showPopover = false

    
    static func generateMeter(confidence: Double, width: CGFloat, height: CGFloat) -> some View {
        GeometryReader { geometry in
            let gradient = LinearGradient(
                gradient: Gradient(colors: [.barGradientPurple, .barGradientLightPurple, .barGradientBlue]),
                startPoint: .bottom,
                endPoint: .top
            )
            
            ZStack(alignment: .bottom) {
                gradient
                    .opacity(0.2)
                gradient
                    .mask(
                        Rectangle()
                            .frame(height: geometry.size.height * CGFloat(confidence))
                            .frame(height: geometry.size.height, alignment: .bottom)
                    )
            }
        }
        .frame(width: width, height: height)
        .animation(.easeInOut, value: confidence)
    }

    
    static func generateDetectionsGrid(_ detections: [(SoundIdentifier, DetectionState)]) -> some View {
        return HStack(spacing: 20){
            ForEach(detections, id: \.0.labelName) { soundIdentifier, detectionState in
                InstrumentBar(confidence: .constant(detectionState.isDetected ? detectionState.currentConfidence : 0.0), instrument: soundIdentifier.instrument)
            }
        }
    }

    var body: some View {
        
        VStack{
        
            ZStack {
                
                Color.black
                
                VStack{
                    
                    DetectSoundsView
                        .generateDetectionsGrid(state.detectionStates)
                    
                }
                .padding(.vertical, 92)
                
            }
            
            
        }
        .overlay(alignment: .bottomLeading){
            Image(systemName: "gearshape")
                .font(.system(size: 30))
                .fontWeight(.semibold)
                .padding(.leading, 60)
                .padding(.bottom, 60)
                .onTapGesture {
                    showPopover = true
                }
                .popover(isPresented: $showPopover) {
                   SettingPopoverView()
                }
        }
        .ignoresSafeArea(.all)
        .navigationBarBackButtonHidden(true)
        .toolbar{
            ToolbarItem(placement: .navigation) {          
                HStack{
                    Image(systemName: "chevron.left")
                    Text("곡 제목 / ")

                }
                .font(.title2)
                .fontWeight(.regular)
                .padding(.vertical)
                .onTapGesture {
                    path.removeLast()
                }
            }
        }

    }
    
}
