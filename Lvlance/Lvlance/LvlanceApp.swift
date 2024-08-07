//
//  LvlanceApp.swift
//  Lvlance
//
//  Created by 지영 on 7/18/24.
//

import SwiftUI

@main
struct LvlanceApp: App {
    //    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var hasSeenOnboarding = false
    
    
    var body: some Scene {
        WindowGroup {
            if hasSeenOnboarding {
                BandSettingView()
                    .preferredColorScheme(.dark)
            }else {
                OnboardingView(hasSeenOnboarding: $hasSeenOnboarding)
                    .preferredColorScheme(.dark)
                    .frame(width: 777, height: 507)
                    .fixedSize(horizontal: true, vertical: true)
            }
        }
        .windowResizability(!hasSeenOnboarding ? .contentSize : .automatic)
    }
}
