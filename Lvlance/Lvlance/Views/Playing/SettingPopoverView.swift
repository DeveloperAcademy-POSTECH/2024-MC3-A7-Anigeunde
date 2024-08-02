//
//  SettingPopoverView.swift
//  Lvlance
//
//  Created by 이종선 on 8/1/24.
//

import SwiftUI

struct SettingPopoverView: View {
    @State private var inputLevel: Double = 0.5
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("입력 레벨")
                .font(.headline)
            Text("전체 입력 레벨을 조절해보세요.")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            HStack(spacing: 2) {
                ForEach(0..<30, id: \.self) { _ in
                    Rectangle()
                        .fill(Color.white.opacity(0.5))
                        .frame(width: 5, height: 20)
                }
            }
            
            Slider(value: $inputLevel, in: 0...1)
                .accentColor(.white)
            
            DisclosureGroup(
                isExpanded: $isExpanded,
                content: {
                    VStack(alignment: .leading) {
                        ForEach(0..<8) { _ in
                            Text("Same as system (MacBook Pro Mic)")
                                .frame(height: 10)
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical)
                },
                label: {
                    Text("입력 기기 선택하기")
                        .foregroundColor(.white)
                }
            )
        }
        .padding()
        .foregroundColor(.white)
    }
}

#Preview {
    SettingPopoverView()
}
