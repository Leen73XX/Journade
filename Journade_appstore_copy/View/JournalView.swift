//
//  journalEntryView.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//

import SwiftUI
import LocalAuthentication


struct JournalView: View {
    @ObservedObject var journalManager: JournalViewModel
    @Environment(\.colorScheme) var colorScheme
    var date: Date
    @State private var isAuthenticated = false
    
    var body: some View {
        NavigationView {
            VStack {
                // Show entries if authenticated, otherwise show the authentication prompt.
                if isAuthenticated {
                    EntryListView(entries: journalManager.entries(for: date), journalManager: journalManager)
                } else {
                    Text("Please authenticate to view your entries.")
                        .foregroundColor(Theme.Text2Color)
                        .font(.headline)
                        .padding()
                }
            }
            .onAppear {
                authenticate()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Journals")
                        .accessibilityLabel("all journals in this date")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(colorScheme == .dark ? Theme.primaryDarkMoodColor : Color(Theme.primaryLightMoodColor))
                }
            }
            .customBackButton()
        }
    }

    // Function for Face ID authentication
    private func authenticate() {
        journalManager.authenticateWithFaceID { success in
            isAuthenticated = success
        }
    }
}

struct EntryListView: View {
    var entries: [JournalEntry]
    var journalManager: JournalViewModel
    
    var body: some View {
        List(entries) { entry in
            VStack(alignment: .leading) {
                // Decrypt entry and display it with emoji
                Text(decryptEntry(entry))
                    .font(.callout)
                
                Text("\(entry.date, formatter: timeFormatter)")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
    
    // Function to decrypt journal entry text
    private func decryptEntry(_ entry: JournalEntry) -> String {
        if let decryptedText = journalManager.decrypt(encryptedText: entry.encryptedText) {
            return decryptedText + " \(entry.empji)"
        } else {
            return "Decryption failed for entry: \(entry)"
        }
    }
}

// Date and Time formatters
let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .medium
    formatter.timeStyle = .none
    return formatter
}()

let timeFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.timeStyle = .short
    return formatter
}()

