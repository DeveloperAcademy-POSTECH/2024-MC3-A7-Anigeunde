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

    var body: some Scene {
        WindowGroup {
            BandSettingView()
                .preferredColorScheme(.dark)
                .environmentObject(audioManager)
        }
        
    }
}
