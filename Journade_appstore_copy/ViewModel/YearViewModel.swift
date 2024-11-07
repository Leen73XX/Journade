//
//  YearViewModel.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//

import Foundation
class YearViewModel: ObservableObject {
    @Published var selectedYear: Int
    @Published var displayYear: String
    
    init() {
        // the current year
        let currentYear = Calendar.current.component(.year, from: Date())
        self.selectedYear = currentYear
        self.displayYear = String(currentYear)
    }
    
    // what is the current Year? example: 2024, 2025
    public static func currentYear() -> Int {
        let calendar = Calendar.current
        return calendar.component(.year, from: Date())
    }
}
