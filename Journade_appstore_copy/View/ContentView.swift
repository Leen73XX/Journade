//
//  ContentView.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//

import SwiftUI

struct ContentView: View {
@StateObject private var journalManager = JournalViewModel()
@State private var journalText: String = ""
@State private var emoji: String = ""
@State private var selectedDate: Date = Date()

    var body: some View {
        NavigationView {
            ScrollView {
            VStack {
                TextField("Write your journal entry...", text: $journalText)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
               
                CalendarView(selectedDate: $selectedDate, journalManager: journalManager)
                
                Spacer()
            }
            .navigationTitle("Daily Journal")
            .padding()
        }}
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
#Preview {
    ContentView()
}
