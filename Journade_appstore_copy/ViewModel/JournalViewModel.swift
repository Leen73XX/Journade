//
//  JournalManager.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//  Edited by mariyam yasin on 12/05/1446 AH.

import Foundation
import CryptoKit
import LocalAuthentication
import WidgetKit

class JournalViewModel: ObservableObject {
    
    @Published var entries: [JournalEntry] = []
    private let storageKey = "journalEntries"
    private var symmetricKey: SymmetricKey

    init() {
        // Initialize the symmetric key first
        if let existingKey = Self.retrieveKey() {
            symmetricKey = existingKey
        } else {
            symmetricKey = SymmetricKey(size: .bits256)
            Self.storeKey(symmetricKey) // Store the new key securely
        }
        loadEntries()
    }

    // Encrypt the journal text
    private func encrypt(text: String) -> String? {
        let data = Data(text.utf8)
        let sealedBox = try? AES.GCM.seal(data, using: symmetricKey)
        
        guard let encryptedData = sealedBox?.combined else { return nil }
        return encryptedData.base64EncodedString()
    }

    // Decrypt the journal text
    func decrypt(encryptedText: String) -> String? {
        guard let data = Data(base64Encoded: encryptedText) else { return nil }
        let sealedBox = try? AES.GCM.SealedBox(combined: data)
        
        guard let decryptedData = try? AES.GCM.open(sealedBox!, using: symmetricKey),
              let decryptedString = String(data: decryptedData, encoding: .utf8) else {
            return nil
        }
        
        return decryptedString
    }

    // need in add entry to save journal
    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            if let defaults = UserDefaults(suiteName: "group.com.jornal.widget") { // App Group identifier
                defaults.set(encoded, forKey: storageKey)
                // UserDefaults.standard.set(encoded, forKey: storageKey)
                
                // Trigger the widget to refresh
                WidgetCenter.shared.reloadTimelines(ofKind: "JournalWidget")
            }
        }
    }

    func loadEntries() {
        if let defaults = UserDefaults(suiteName: "group.com.jornal.widget") { // App Group identifier
            // if let data = UserDefaults.standard.data(forKey: storageKey),
            if let data = defaults.data(forKey: storageKey),
               let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: data) {
                entries = decodedEntries
            }
        }
    }

    func addEntry(text: String, for date: Date, emoji: String) {
        if let encryptedText = encrypt(text: text) {
            let newEntry = JournalEntry(date: date, encryptedText: encryptedText, empji: emoji)
            entries.append(newEntry)
            saveEntries()
        }
    }
    // for edit button in journal page to delete journal
    func deleteEntry(_ entry: JournalEntry) {
            if let index = entries.firstIndex(where: { $0.id == entry.id }) {
                entries.remove(at: index) // Remove from array
               
            }
        }
    func entries(for date: Date) -> [JournalEntry] {
        return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    
    // Face ID authentication
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?

        // Check if the device supports Face ID or other biometric authentication
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to access your journal entries."

            // Try to authenticate using Face ID or Touch ID
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        // If Face ID succeeds
                        completion(true)
                    } else {
                        // fails
                        // show an alert or ask for password authentication
                        self.fallbackToPasswordAuthentication(completion: completion)
                    }
                }
            }
        } else {
            // If not available it will be back to password authentication directly
            self.fallbackToPasswordAuthentication(completion: completion)
        }
    }
    
    // password
    func fallbackToPasswordAuthentication(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        let reason = "Please authenticate to access your journals using your password."

        // Attempt to authenticate using a password
        context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
            DispatchQueue.main.async {
                if success {
                    // If  successful
                    completion(true)
                } else {
                    // If fails 
                    completion(false)
                }
            }
        }
    }

    // Store the symmetric key securely
    private static func storeKey(_ key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data($0) }
        if let defaults = UserDefaults(suiteName: "group.com.jornal.widget") { // App Group identifier
            defaults.set(keyData, forKey: "symmetricKey")
            //        UserDefaults.standard.set(keyData, forKey: "symmetricKey")
        }
    }

    // Retrieve the symmetric key
    private static func retrieveKey() -> SymmetricKey? {
        guard let defaults = UserDefaults(suiteName: "group.com.jornal.widget") else { return nil }// App Group identifier
        guard let keyData = defaults.data(forKey: "symmetricKey") else {
            //        guard let keyData = UserDefaults.standard.data(forKey: "symmetricKey") else {
            return nil
        }
        return SymmetricKey(data: keyData)
    }
    
    // for wedgit
    func saveQuickThought(_ thought: String) {
        if let encryptedText = encrypt(text: thought) {
            let newEntry = JournalEntry(date: Date(), encryptedText: encryptedText, empji: "💭")
            entries.append(newEntry)
            saveEntries()
        }
    }
    }
