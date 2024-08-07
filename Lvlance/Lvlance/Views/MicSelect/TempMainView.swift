//
//  TempMainView.swift
//  Lvlance
//
//  Created by 이종선 on 8/6/24.
//

import SwiftUI

struct TempMainView: View {
    
    @StateObject private var audioManager = AudioManager()
    @State private var isShowingMicrophoneSelector = false
    
    var body: some View {
        
        VStack{
            
            
        }
        .sheet(isPresented: $isShowingMicrophoneSelector) {
            MicSelectView(isShowingMicrophoneSelector: $isShowingMicrophoneSelector)
        }
        .onAppear{
            isShowingMicrophoneSelector = true
            Task {
                await audioManager.start()
            }
        }
        .environmentObject(audioManager)
    }
}

#Preview {
    TempMainView()
}
