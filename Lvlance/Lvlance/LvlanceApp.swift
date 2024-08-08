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
    //    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var hasSeenOnboarding = false
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                BandSettingView()
                    .preferredColorScheme(.dark)
                    .environmentObject(audioManager)
            } else{
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .preferredColorScheme(.dark)
                    .fixedSize(horizontal: true, vertical: true)
            }
        }
        .windowResizability(!hasSeenOnboarding ? .contentSize : .automatic)
    }
}
