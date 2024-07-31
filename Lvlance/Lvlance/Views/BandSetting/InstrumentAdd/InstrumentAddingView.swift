//
//  InstrumentAddingView.swift
//  Lvlance
//
//  Created by 지영 on 7/31/24.
//

import SwiftUI

struct InstrumentAddingView: View {
    @State private var isSelected = true
    var body: some View {
        VStack {
            Text("이 곡에서 연주할 악기를 선택해주세요.")
                .font(.system(size: 13).bold())
                .padding(.vertical, 32)
            HStack {
                ForEach(0...4, id: \.self) { _ in
                    InstrumentSelectButton()
                }
            }
            Spacer()
                .frame(height: 42)
            
            HStack {
                Spacer()
                
                Button {
                    print("취소")
                } label: {
                    Text("취소")
                }

                
                Button {
                    print("편집")
                } label: {
                    Text("편집")
                }
                .buttonStyle(.borderedProminent)
            }
            .padding([.trailing, .bottom], 20)
        }
    }
}

#Preview {
    InstrumentAddingView()
}
