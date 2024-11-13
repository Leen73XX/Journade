//
//  OnboardingView.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 05/05/1446 AH.
//

import Foundation
import SwiftUI

struct OnboardingView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @StateObject private var viewModel = OnboardingViewModel()
    @State private var isAnimating = false
    
    var body: some View {
        
        NavigationView{
            VStack(alignment: .center, spacing: 40) {
                HStack{
                    Spacer()
                    NavigationLink(destination: chatPageView()
                        .navigationBarBackButtonHidden(true)
                    ){
                        Text("Skip")
                            .font(.headline)
                            .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                        
                    }.accessibilityAddTraits([.isButton])
                        .accessibilityLabel("skip")
                }.padding()
                Spacer()
                Text(viewModel.currentStep.title)
                    .accessibilityLabel("\(viewModel.currentStep.title)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                // onbourding 1
                if (viewModel.currentStep.imageName == "Onboardind1"){
                    Image(viewModel.currentStep.imageName)
                        .resizable()
                        .frame(width: 260, height: 200)
                        .overlay(
                            VStack (alignment: .trailing){
                                Spacer()
                                TypingIndicatorView()
                                
                                Spacer()
                                Spacer()
                            }
                        )
                }else{
                    // onbourding 3
                    if (viewModel.currentStep.imageName == "Onboarding3"){
                        Image(viewModel.currentStep.imageName)
                            .resizable()
                            .frame(width: 90, height: 180)
                    }
                    // onbourding 2
                    if (viewModel.currentStep.imageName == "Onboarding2"){
                        Image(viewModel.currentStep.imageName)
                            .resizable()
                            .frame(width: 210, height: 180)
                    }
                }
                
                Text(viewModel.currentStep.description)
                    .accessibilityLabel("\(viewModel.currentStep.description)")
                    .font(.body)
                    .multilineTextAlignment(.center)
                
                // Dot Indicator
                HStack {
                    ForEach(0..<viewModel.steps.count, id: \.self) { index in
                        Circle()
                            .fill(index == viewModel.currentStepIndex ? colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor) : Color.gray)
                            .frame(width: 10, height: 10)
                            .onTapGesture {
                                viewModel.currentStepIndex = index
                            }
                    }
                }
                
                Spacer()
                
                if viewModel.isLastStep() {
                    NavigationLink(destination: chatPageView().navigationBarBackButtonHidden(true)) {
                        Text("let's start!")
                            .accessibilityAddTraits([.isButton])
                            .accessibilityLabel("Got it, let's start!")
                            .font(.headline)
                            .multilineTextAlignment(.center)
                            .padding()
                            .frame(width: 240,height: 50)
                            .background(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                            .foregroundColor(.white)
                            .cornerRadius(30)
                    }
                    
                    
                }else {
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.nextStep()
                            UserDefaults.standard.set(true, forKey: "hasSeenOnboarding")
                        }) {
                            Text("Next")
                                .accessibilityAddTraits([.isButton])
                                .accessibilityLabel("next")
                                .font(.headline)
                                .padding()
                                .frame(width: 100,height: 50)
                                .background(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                                .foregroundColor(.white)
                                .cornerRadius(30)
                        }
                    }
                    
                }
            }.padding()
                .animation(
                    Animation.snappy)
        }
    }
}
#Preview {
    OnboardingView()
}
