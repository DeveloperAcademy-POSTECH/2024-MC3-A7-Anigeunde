//
//  OnboardingView.swift
//  Lvlance
//
//  Created by 김하준 on 7/31/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @Binding var hasSeenOnboarding: Bool
    
    var body: some View {
        VStack {
            switch currentStep {
            case 0:
                OnboardingStartView(
                    image: "image",
                    description: "밴드의 전체 소리를 입력할 김태린의 아이폰을 스피커 앞에 둡니다.",
                    buttonText: "다음",
                    action: {
                        currentStep += 1
                    }
                )
            case 1:
                OnboardingNextView(
                    image: "image",
                    description: "멘트는 무엇으로 할까요?",
                    buttonText: "다음",
                    backAction: {
                        currentStep -= 1
                        
                    },
                    action: {
                        currentStep += 1
                    }
                )
            case 2:
                OnboardingNextView(
                    image: "image",
                    description: "메롱 약오르지롱",
                    buttonText: "완료",
                    backAction: {
                        currentStep -= 1
                    },
                    action: {
                        currentStep += 1
                        hasSeenOnboarding = true
                    }
                )
            default:
                ContentView()
            }
        }
    }
}
