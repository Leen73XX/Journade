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
    @State private var editMode: EditMode = .inactive
    
    var body: some View {
        NavigationView {
            VStack {
                // Show entries if authenticated, otherwise show the authentication prompt.
                if isAuthenticated {
                    EntryListView(entries: journalManager.entries(for: date), journalManager: journalManager, editMode: $editMode)
                } else {
                    Text("Please authenticate to view your journals.")
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
                // edit button
                ToolbarItem(placement: .navigationBarTrailing) {
                                   Button(action: {
                                       withAnimation {
                                           editMode = editMode == .active ? .inactive : .active
                                       }
                                   }) {
                                       Text(editMode == .active ? "Done" : "Edit") 
                                           .foregroundColor(colorScheme == .dark ? Theme.primaryDarkMoodColor : Color(Theme.primaryLightMoodColor))
                                   }
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
    @Binding var editMode: EditMode
    var body: some View {
        List {
            ForEach(entries) { entry in
                       VStack(alignment: .leading) {
                           // Decrypt entry and display it with emoji
                           Text(decryptEntry(entry))
                               .font(.callout)
                           
                           Text("\(entry.date, formatter: timeFormatter)")
                               .font(.subheadline)
                               .foregroundColor(.gray)
                       }
                   }
                   .onDelete(perform: deleteEntry)
            
        }.environment(\.editMode, $editMode)
        
    }
    private func deleteEntry(at offsets: IndexSet) {
         for index in offsets {
             let entry = entries[index]
             journalManager.deleteEntry(entry) // Implement the delete function in your JournalViewModel
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

