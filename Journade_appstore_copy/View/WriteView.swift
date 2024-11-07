//
//  WriteView.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//

import Foundation
import SwiftUI
import Combine


struct chatPageView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var writeViewModel = WriteViewModel()
    @State var messageOpacity = 1.0
    
    // messages
    @State var showNoJournalEnterMessage = false
    @State var JournalHasSended = false
    
    // timer in JournalHasSended message
    @State private var timeRemaining: Int = 5 // Set your countdown duration here
    @State private var timer: AnyCancellable? // To hold the timer subscription
    @State private var isCountingDown = false // To track if the countdown is active
    
    // save locally
    @StateObject private var journalManager = JournalViewModel()
    @State private var selectedDate: Date = Date()
    @State private var mood = ["😃", "😞", "☹️", "😡", "😊", "😆", "😢"]
    @State private var selectedMood = ""
    @State private var showConfirmationAlert = false
    
    var body: some View {
        NavigationView { // Wrap the content inside NavigationView
            ZStack {
                // Background color that extends to edges of the screen, including the toolbar
                Color(colorScheme == .dark ? Color.black : Theme.backgroundLightMoodColor)
                    .ignoresSafeArea() // This ensures the background extends behind the navigation bar
                
                VStack(alignment: .leading, spacing: 20) {
                    moodSelectionView
                    journalEntryView
                    
                    Spacer()
                }
                
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Journal")
                        .accessibilityLabel("write journal page")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(colorScheme == .dark ? Theme.primaryDarkMoodColor : Color(Theme.primaryLightMoodColor))
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: CalendarView(selectedDate: $selectedDate, journalManager: journalManager).navigationBarBackButtonHidden()) {
                        ZStack {
                            Circle()
                                .frame(width: 40, height: 40)
                                .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                            Image(systemName: "chart.xyaxis.line")
                                .resizable()
                                .frame(width: 20, height: 20)
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 10.0)
                        .accessibilityLabel("Go to analysis page")
                    }
                }
            }
            // Use .toolbarBackground(.hidden()) to hide the navigation bar's background color
            .toolbarBackground(.hidden , for: .navigationBar)
           
        }
    }
    
    // Timer to reset the journal text after sending
    func startHiddenTextTimer() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            withAnimation(.easeInOut(duration: 0.5)) {
                writeViewModel.journal = ""
            }
        }
    }
    
    // Countdown function for the timer
    func startCountdown() {
        guard !isCountingDown else { return }
        isCountingDown = true
        timer = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { _ in
                if self.timeRemaining > 0 {
                    self.timeRemaining -= 1
                } else {
                    self.timer?.cancel()
                    self.isCountingDown = false
                }
            }
    }
    private var moodSelectionView: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Mood Today")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(Theme.Text2Color)
            
            // Mood selection UI
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(colorScheme == .dark ? Theme.backgroundDarkMoodColor : Color.white)
                .frame(width: .infinity, height: 80)
                .overlay(
                    HStack {
                        ScrollView(.horizontal) {
                            HStack(spacing: 10) {
                                ForEach(mood, id: \.self) { moodEmoji in
                                    Button(action: {
                                        selectedMood = moodEmoji
                                    }) {
                                        Text(moodEmoji)
                                            .font(.largeTitle)
                                    }
                                    .padding(10.0)
                                    .background(
                                        selectedMood == moodEmoji ? Theme.primaryLightMoodColor.opacity(0.2) : Color.clear
                                    )
                                    .cornerRadius(15)
                                }
                            }
                        }
                    }
                )
        }
        .padding()
    }
    private var journalEntryView: some View {
        RoundedRectangle(cornerRadius: 30)
            .foregroundColor(colorScheme == .dark ? Theme.backgroundDarkMoodColor : Color.white)
            .frame(width: .infinity)
            .overlay(
                VStack {
                    TextField("What's on your mind today?", text: $writeViewModel.journal)
                        .accessibilityLabel("What's on your mind today? write your journal here")
                        .font(.title3)
                        .padding(.top, 20.0)
                       
                    
                    Spacer()
                    
                    if JournalHasSended {
                        if timeRemaining > 0 {
                            
                            Text("The journal will save in \(timeRemaining) seconds")
                                .accessibilityLabel("The journal will be sent")
                                .font(.footnote)
                                .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                                .opacity(1)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
                                        JournalHasSended = false
                                    }
                                }
                        }
                    }
                    
                    
                    if showNoJournalEnterMessage {
                        Text("Please write something before sending")
                            .accessibilityLabel("Please write something before sending")
                            .font(.footnote)
                            .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                            .opacity(1)
                            .onAppear {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    messageOpacity = 0.0
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                                    showNoJournalEnterMessage = false
                                    messageOpacity = 1.0
                                }
                            }
                    }
                    sendButtonView
                }
                    .padding(.all)
            ).padding()
    }
    private var sendButtonView: some View {
        HStack {
            Spacer()
            
            // Send button
            Button(action: {
                if !writeViewModel.journal.isEmpty {
                    // Show the confirmation alert
                    showConfirmationAlert = true
                    
                } else {
                    showNoJournalEnterMessage = true
                }
            }) {
                ZStack {
                    Circle()
                        .frame(width: 50, height: 50)
                        .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                    Image(systemName: "paperplane")
                        .resizable()
                        .frame(width: 25, height: 25)
                        .foregroundColor(.white)
                }
            }
            .accessibilityLabel("Send Journal Entry")
            .alert(isPresented: $showConfirmationAlert) {
                Alert(
                    title: Text("Save Your Journal"),
                    message: Text("Do you want to keep this entry, or would you prefer it to fade away?"),
                    primaryButton: .default(Text("Keep")) {
                        
                        // User chooses to keep and send the entry
                        journalManager.addEntry(text: writeViewModel.journal, for: selectedDate, emoji: selectedMood)
                        JournalHasSended = true
                        startHiddenTextTimer()
                        startCountdown()
                        // Start the timer to clear the journal after sending
                    },
                    secondaryButton: .destructive(Text("Fade")) {
                        // User chooses to delete, clearing the journal and emoji
                        
                        writeViewModel.journal = "" // Clear the journal text
                        selectedMood = "" // Clear the emoji selection
                    }
                )
            }
        }
    }
}
#Preview {
    chatPageView()
}
