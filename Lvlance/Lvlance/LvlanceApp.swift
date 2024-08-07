//
//  LvlanceApp.swift
//  Lvlance
//
//  Created by 지영 on 7/18/24.
//

import SwiftUI

@main
struct LvlanceApp: App {
//    @StateObject private var songViewModel = SongViewModel()
    
    var body: some Scene {
        WindowGroup {
            BandSettingView()
//                .environment(\.managedObjectContext, coreDataManager.persistentContainer.viewContext)
                .preferredColorScheme(.dark)
//                .environmentObject(songViewModel)
        }
        

    }
}
