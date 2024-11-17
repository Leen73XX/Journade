//
//  JournalModel.swift
//  Journade_appstore_copy
//
//  Created by Leen Almejarri on 05/05/1446 AH.
//

import Foundation

struct JournalEntry: Codable, Identifiable {
    var id: UUID = UUID()
    var date: Date
    var encryptedText: String
    var empji : String
    
}
