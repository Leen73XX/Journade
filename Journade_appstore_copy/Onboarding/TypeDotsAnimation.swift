//
//  TypeDotsAnimation.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 05/05/1446 AH.
//


import Foundation
import SwiftUI

struct TypingIndicatorView: View {
    @Environment(\.colorScheme) var colorScheme
    @State private var isAnimating = false
    @State private var currentIndex = 0
    @State private var dotOpacity: [Double] = [1.0, 0.5, 0.5]
    
    var body: some View {
        RoundedRectangle(cornerRadius: 16).frame(width:70 ,height: 40)
            .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
            .overlay(
        HStack(spacing: 5) {
            ForEach(0..<3, id: \.self) { index in
                Circle()
                    .frame(width: 10, height: 10)
                    .foregroundColor(.white)
                    .opacity(dotOpacity[index])
                     }
        }.animation(
            Animation.smooth
        )
                 .onAppear {
                     startDotAnimation()
                 }
        )
    }

    private func startDotAnimation() {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            for i in 0..<3 {
                dotOpacity[i] = (i == currentIndex) ? 1.0 : 0.5
            }
            
            currentIndex = (currentIndex + 1) % 3
        }
    }
}
