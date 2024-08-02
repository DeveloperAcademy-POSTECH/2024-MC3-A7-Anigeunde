//
//  TempView.swift
//  Lvlance
//
//  Created by 이종선 on 8/1/24.
//

import SwiftUI

struct TempView : View {
    
    @StateObject var appState = AppState()
    @State var appConfig = AppConfiguration()
    
    var body: some View {
            SetupMonitoredSoundsView(appState: appState, appConfig: $appConfig)
           
    }
}
