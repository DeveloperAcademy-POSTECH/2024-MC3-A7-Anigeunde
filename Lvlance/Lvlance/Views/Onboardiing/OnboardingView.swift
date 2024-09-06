//
//  OnboardingView.swift
//  Lvlance
//
//  Created by 김하준 on 7/31/24.
//

import SwiftUI

struct OnboardingView: View {
    @State private var currentStep = 0
    @Binding var isShowOnboarding: Bool
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    
    var body: some View {
        VStack {
            switch currentStep {
            case 0:
                OnboardingStartView(
                    image: "onboardingImage1",
                    description: String(localized: "onboarding.step1.description"),
                    buttonText: String(localized: "onboarding.button.next"),
                    action: {
                        currentStep += 1
                    }
                )
            case 1:
                OnboardingNextView(
                    image: "onboardingImage2",
                    description: String(localized: "onboarding.step2.description"),
                    buttonText: String(localized: "onboarding.button.next"),
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
                    description: String(localized: "onboarding.step3.description1") + "\n" + String(localized: "onboarding.step3.description2"),
                    buttonText: String(localized: "onboarding.button.complete"),
                    backAction: {
                        currentStep -= 1
                    },
                    action: {
                        currentStep += 1
                        hasSeenOnboarding = true
                        isShowOnboarding = false
                    }
                )
            default:
                BandSettingView()
            }
        }
        .frame(width: 777, height: 507)
    }
}
