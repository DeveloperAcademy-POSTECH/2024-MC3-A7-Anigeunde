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
            .font(.system(size: 42))
            .foregroundStyle(.white)
            .background(.clear)
    }
}

struct sideBarButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(Color(.systemPurple))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .scaleEffect(configuration.isPressed ? 0.95 : 1.0)
    }
}
