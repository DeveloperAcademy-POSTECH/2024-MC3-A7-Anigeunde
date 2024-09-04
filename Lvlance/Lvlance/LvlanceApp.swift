//
//  LvlanceApp.swift
//  Lvlance
//
//  Created by 지영 on 7/18/24.
//

import SwiftUI

@main
struct LvlanceApp: App { 
    
    @StateObject var audioManager = AudioManager()
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    //@State private var hasSeenOnboarding = false
    @State private var isShowOnboarding = false
    @State var isShowingMicrophoneSelector = false
    
    init() {
         #if DEBUG
         // 개발 중에는 AppStorage 값을 초기화
         UserDefaults.standard.removeObject(forKey: "hasSeenOnboarding")
         #endif
     }
    
    var body: some Scene {
        WindowGroup {
            BandSettingView()
                .preferredColorScheme(.dark)
                .onAppear{
                    if !hasSeenOnboarding {
                        isShowOnboarding = true
                    } else {
                        showMicrophoneSelector()
                    }
                }
                .sheet(isPresented: $isShowOnboarding, onDismiss: {
                    showMicrophoneSelector()
                }, content: {
                    OnboardingView(isShowOnboarding: $isShowOnboarding)
                })
                .sheet(isPresented: $isShowingMicrophoneSelector, content: {
                    MicSelectView(isShowingMicrophoneSelector: $isShowingMicrophoneSelector)
                })
        }
        .environmentObject(audioManager)
    }
    
    private func showMicrophoneSelector() {
        isShowingMicrophoneSelector = true
        Task {
            await audioManager.start()
        }
    }
}
