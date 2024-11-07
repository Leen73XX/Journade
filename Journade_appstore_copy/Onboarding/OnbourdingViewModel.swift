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
        Onboarding(title: "Express Freely, Privately", description: "Express yourself freely with AI—your thoughts are completely private", imageName: "Onboarding1"),
        Onboarding(title: "Personal Insights, Tailored for You", description: "Receive weekly insights to monitor your personality and emotions through your journal entries.", imageName: "Onboarding2"),
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
