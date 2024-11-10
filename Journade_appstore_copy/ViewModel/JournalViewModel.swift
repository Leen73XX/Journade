//
//  JournalManager.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//

import Foundation
import CryptoKit
import LocalAuthentication


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

    func saveEntries() {
        if let encoded = try? JSONEncoder().encode(entries) {
            UserDefaults.standard.set(encoded, forKey: storageKey)
        }
    }

    func loadEntries() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decodedEntries = try? JSONDecoder().decode([JournalEntry].self, from: data) {
            entries = decodedEntries
        }
    }

    func addEntry(text: String, for date: Date, emoji: String) {
        if let encryptedText = encrypt(text: text) {
            let newEntry = JournalEntry(date: date, encryptedText: encryptedText, empji: emoji)
            entries.append(newEntry)
            saveEntries()
        }
    }
    func deleteEntry(_ entry: JournalEntry) {
            if let index = entries.firstIndex(where: { $0.id == entry.id }) {
                entries.remove(at: index) // Remove from array
               
            }
        }
    func entries(for date: Date) -> [JournalEntry] {
        return entries.filter { Calendar.current.isDate($0.date, inSameDayAs: date) }
    }
    // faceID authentication
    func authenticateWithFaceID(completion: @escaping (Bool) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            let reason = "Please authenticate to access your journal entries."
            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    completion(success)
                }
            }
        } else {
            completion(false)
        }
    }

    // Store the symmetric key securely
    private static func storeKey(_ key: SymmetricKey) {
        let keyData = key.withUnsafeBytes { Data($0) }
        UserDefaults.standard.set(keyData, forKey: "symmetricKey")
    }

    // Retrieve the symmetric key
    private static func retrieveKey() -> SymmetricKey? {
        guard let keyData = UserDefaults.standard.data(forKey: "symmetricKey") else {
            return nil
        }
        return SymmetricKey(data: keyData)
    }
    }
