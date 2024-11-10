//
//  OnboardingViewModel.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 05/05/1446 AH.
//

import Foundation
import SwiftUI
import Combine

class OnboardingViewModel: ObservableObject {
    @Published var currentStepIndex: Int = 0
    @Published var dotCount: Int = 1
    let steps: [Onboarding] = [
        Onboarding(title: "Express Yourself Freely", description: "Your thoughts are private. Keep your entries or let them fade away—your choice.", imageName: "Onboardind1"),
        Onboarding(title: "Your Journal, Fully Protected", description: "Rest assured—your entries are safe, private, and securely locked with Face ID.", imageName: "Onboarding2"),
        Onboarding(title: "Daily Motivation, Designed for You", description: "Add our widget for personalized encouragement and start each day with insights tailored to you.", imageName: "Onboarding3")
    ]
    
    var currentStep: Onboarding {
        steps[currentStepIndex]
    }
    
    func nextStep() {
        if currentStepIndex < steps.count - 1 {
            currentStepIndex += 1
        }
    }
    
    func isLastStep() -> Bool {
        return currentStepIndex == steps.count - 1
    }
    func startDotAnimation() {
            Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
                if self.dotCount < 3 {
                    self.dotCount += 1
                } else {
                    self.dotCount = 1
                }
            }
        }
}
