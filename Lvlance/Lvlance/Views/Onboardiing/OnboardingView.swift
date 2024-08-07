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
                    image: "onboardingImage1",
                    description: "밴드의 전체 소리를 입력할 iPhone을 관객 쪽을 향하는 스피커의 앞에 둡니다.",
                    buttonText: "다음",
                    action: {
                        currentStep += 1
                    }
                )
            case 1:
                OnboardingNextView(
                    image: "onboardingImage2",
                    description: "밴드의 전체 소리를 입력할 iPhone을 macBook에 선으로 연결합니다.",
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
                    image: "onboardingImage3",
                    description: "Lvlance는 밴드 연주 중, 관객에게 들리는 밴드의 전체 소리를 연주자가 시각적으로 알 수 있는 앱입니다.\n지금 바로 입력 기기를 연결하여 Lvlance를 사용해 보세요!",
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
