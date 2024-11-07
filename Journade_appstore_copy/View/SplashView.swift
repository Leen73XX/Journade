//
//  SplashView.swift
//  Journade_2
//
//  Created by Leen Almejarri on 03/05/1446 AH.
//

import Foundation
import Foundation
import SwiftUI
struct SplashScreenView: View {
    @State var isActive : Bool = false
    @State private var size = 0.01
    @State private var opacity = 0.5
    @State private var hasSeenOnboarding = UserDefaults.standard.bool(forKey: "hasSeenOnboarding")
    
    var body: some View {
        if isActive {
            if hasSeenOnboarding {
                chatPageView()
            } else {
                OnboardingView()
            }
        } else {
            
                VStack {
                    VStack {
                        Image("Splash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 180, height: 150)
                            .font(.system(size: 50))
                            .foregroundColor(.white)
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.5)) {
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                        withAnimation {
                            self.isActive = true
                        }
                    }
                }
            
        }
    }
}
#Preview {
    SplashScreenView(isActive: false)
}
