//
//  Theme.swift
//  Journade_2
//
//  Created by Leen Almejarri on 17/04/1446 AH.
//

import Foundation
import SwiftUI
struct Theme {
    // light mood
    static let primaryLightMoodColor = Color(Color(hex: "687DAC"))
    static let backgroundLightMoodColor = Color(Color(hex: "FCFAFA"))
    
    // dark mood
    static let primaryDarkMoodColor = Color(Color(hex: "7BB5F9"))
    static let backgroundDarkMoodColor = Color(Color(hex: "1C1C1C"))
    
    // both
    static let Text2Color = Color(Color(hex: "707070"))
    
}

extension Color {
    init(hex: String) {
        if hex == "green" || hex == "blue" || hex == "purple" || hex == "highlighted" {
            self.init(hex)
        } else {
            let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
            var int: UInt64 = 0
            Scanner(string: hex).scanHexInt64(&int)
            let a, r, g, b: UInt64
            switch hex.count {
            case 3: // RGB (12-bit)
                (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
            case 6: // RGB (24-bit)
                (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
            case 8: // ARGB (32-bit)
                (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
            default:
                (a, r, g, b) = (1, 1, 1, 0)
            }
            
            self.init(
                .sRGB,
                red: Double(r) / 255,
                green: Double(g) / 255,
                blue:  Double(b) / 255,
                opacity: Double(a) / 255
            )
        }
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
struct CustomBackButton: ViewModifier {
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true) // Hide the default back button
            .navigationBarItems(leading: Button(action: {
                presentationMode.wrappedValue.dismiss()
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                    .font(.body)
            })
    }
}

extension View {
    func customBackButton() -> some View {
        self.modifier(CustomBackButton())
    }
}
