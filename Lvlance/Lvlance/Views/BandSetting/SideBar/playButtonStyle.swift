//
//  playButtonStyle.swift
//  Lvlance
//
//  Created by 지영 on 8/1/24.
//

import SwiftUI

struct playButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.system(size: 24))
            .foregroundStyle(.white)
            .background(.clear)
    }
}
