//
//  QuitPopoverView.swift
//  Lvlance
//
//  Created by 이종선 on 9/3/24.
//

import SwiftUI

struct QuitPopoverView: View {
    
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment:.center){
            Text("연주를 완료하고 이전 화면으로 이동하시겠어요?")
            
            Text("이동하기")
                .padding()
                .background{
                    RoundedRectangle(cornerRadius: 4)
                        .fill(.systemPurple)
                        .frame(width: 160, height: 30)
                }
                .onTapGesture {
                    path.removeLast()
                }
                
        }
        .frame(minWidth: 320, minHeight: 90)
        .padding()
    }
}
