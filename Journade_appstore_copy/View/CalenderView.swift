//
//  ContentView.swift
//  Journade_New_Solution2_WithoutSwiftData
//
//  Created by Leen Almejarri on 04/05/1446 AH.
//

import SwiftUI
import TipKit

struct CalendarView: View {
    @Environment(\.colorScheme) var colorScheme
    @Binding var selectedDate: Date
    @ObservedObject var journalManager: JournalViewModel
    
    @State private var selectedMonth: Int
    @State private var selectedYear: Int
    
    @State var currentYear = YearViewModel.currentYear()
    @State var calenderSaveJournalTip_ = CalenderSaveJournalTip()
    // Columns for the grid, 7 columns for each day of the week
    let columns = Array(repeating: GridItem(.flexible()), count: 7)
    
    // Weekday names (Sun, Mon, Tue, etc.)
    let weekdays = Calendar.current.shortWeekdaySymbols
    
    // Month Formatter
    let monthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM" // Full month name, e.g., "January"
        return formatter
    }()
    
    // Initialize the selected month and year based on the current date
    init(selectedDate: Binding<Date>, journalManager: JournalViewModel) {
        let currentDate = Date()
        self._selectedMonth = State(initialValue: Calendar.current.component(.month, from: currentDate))
        self._selectedYear = State(initialValue: Calendar.current.component(.year, from: currentDate))
        self._selectedDate = selectedDate
        self.journalManager = journalManager
    }
    
    var body: some View {
        let days = daysInMonth(for: selectedMonth, year: selectedYear)

        NavigationView {
           
            ZStack {
             
                // Background rounded rectangle
                RoundedRectangle(cornerRadius: 30)
                    .fill(colorScheme == .dark ? Color.black : Color(Theme.backgroundLightMoodColor))
                    .edgesIgnoringSafeArea(.all) // covers the entire screen

                VStack(alignment: .leading, spacing: 30) {
                    TipView(calenderSaveJournalTip_)
                        
                    Text("Select a Day to View Your Journals")
                        .fontWeight(.bold)
                        .foregroundColor(Theme.Text2Color)

                    ZStack {
                        RoundedRectangle(cornerRadius: 30)
                            .foregroundColor(colorScheme == .dark ? Theme.backgroundDarkMoodColor : Color.white)
                            .frame(height: 430)

                        VStack {
                            monthYearSelectorView

                            calendarView(days: days)
                        }
                        .padding()
                    }
                }
                .padding()
            }
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("Journade")
                        .accessibilityLabel("all journals page")
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top)
                        .foregroundColor(colorScheme == .dark ? Theme.primaryDarkMoodColor : Color(Theme.primaryLightMoodColor))
                }
            }
            .toolbarBackground(.hidden, for: .navigationBar)
            .customBackButton()
        }
    }

    private var monthYearSelectorView: some View {
        HStack(spacing: 20) {
            monthYearSelector
        }
        .padding()
    }
    private func calendarView(days: [Date]) -> some View {
        VStack {
            // Weekday header
            weekdayHeaderView

            // Calendar grid with days
            calendarGridView(days: days)
        }
        .padding()
    }
    private var weekdayHeaderView: some View {
        HStack {
            ForEach(weekdays, id: \.self) { weekday in
                Text(weekday)
                    .frame(maxWidth: .infinity)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .padding(.vertical, 4)
                    .padding(.horizontal, 2)
            }
        }
    }
    private func calendarGridView(days: [Date]) -> some View {
        LazyVGrid(columns: columns) {
            // Create empty cells before the first day of the month
            ForEach(0..<paddingDays(for: selectedMonth, year: selectedYear), id: \.self) { _ in
                Text("")
                    .frame(width: 30, height: 30)
                    .background(Color.clear)
            }

            // Add the actual days of the month
            ForEach(days, id: \.self) { day in
                NavigationLink(destination: JournalView(journalManager: journalManager, date: day).navigationBarBackButtonHidden()) {
                    Text("\(Calendar.current.component(.day, from: day))")
                        .frame(width: 30, height: 30)
                        .background(
                            // Highlight current date with a special color
                            Calendar.current.isDateInToday(day)
                                ? colorScheme == .dark ? Theme.primaryDarkMoodColor : Theme.primaryLightMoodColor
                                : Color.clear
                        )
                       
                        .cornerRadius(10)
                        .foregroundColor(
                            // Set text color for the current day and selected day
                            Calendar.current.isDateInToday(day) ? colorScheme == .dark ? Color.black : Color.white : .primary
                        )
                        .padding(5)
                }.onTapGesture {
                    calenderSaveJournalTip_.invalidate(reason: .tipClosed)
                    }

                    
            }
        }
    }

    // Function to calculate the days in the selected month
    private func daysInMonth(for month: Int, year: Int) -> [Date] {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else {
            return []
        }
        
        let range = calendar.range(of: .day, in: .month, for: firstDayOfMonth)!
        let days = range.compactMap { day -> Date? in
            calendar.date(bySetting: .day, value: day, of: firstDayOfMonth)
        }
        
        return days
    }
    
    // Function to calculate how many empty cells need to be added before the first day
    private func paddingDays(for month: Int, year: Int) -> Int {
        let calendar = Calendar.current
        let dateComponents = DateComponents(year: year, month: month)
        
        // Get the first day of the month
        guard let firstDayOfMonth = calendar.date(from: dateComponents) else {
            return 0
        }
        
        // Find the weekday of the first day of the month (1 = Sunday, 7 = Saturday)
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        // If the first day of the month is a Sunday (weekday 1)
        return weekday == 1 ? 0 : weekday - 1
    }
    
    // Function to update the selected date whenever month or year is changed
    private func updateSelectedDate() {
        let calendar = Calendar.current
        let newDateComponents = DateComponents(year: selectedYear, month: selectedMonth, day: 1)
        if let newDate = calendar.date(from: newDateComponents) {
            selectedDate = newDate
        }
    }
    
    private var yearSelector: some View {
        HStack {
            Text("\(String(selectedYear))")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                .accessibilityLabel("The selected year is \(selectedYear)")
            
            Spacer()
        }
    }
    
    private var monthYearSelector: some View {
        HStack {
            
            // Show the current selected month
            Text(monthFormatter.string(from: Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth))!))
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                .accessibilityLabel("The selected month is \(monthFormatter.string(from: Calendar.current.date(from: DateComponents(year: selectedYear, month: selectedMonth))!))")
            
            // Display the selected year without a comma
            Text("\(String(selectedYear))")
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                .accessibilityLabel("The selected year is \(selectedYear)")
            
            Spacer()
            
            HStack(spacing: 40) {
                
                // Previous Month Button
                Button(action: {
                    if selectedMonth > 1 { // Move to previous month if not in January
                        selectedMonth -= 1
                    } else {
                        if selectedYear > 2024 { // Go back to December of the previous year
                            selectedYear -= 1
                            selectedMonth = 12 // Go to December
                        }
                    }
                    // Update the selected date
                    updateSelectedDate()
                }) {
                    Image(systemName: "chevron.left")
                        .resizable()
                        .frame(width: 10, height: 15)
                        .foregroundColor( colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                }
                .accessibilityLabel("Go to previous month")
                .accessibilityAddTraits([.isButton])
                
                // Next Month Button
                Button(action: {
                    if selectedMonth < 12 { // Move to next month if not in December
                        selectedMonth += 1
                    } else {
                        if selectedYear < currentYear { // Go to January of the next year if not beyond current year
                            selectedYear += 1
                            selectedMonth = 1 // Go to January
                        }
                    }
                    // Update the selected date
                    updateSelectedDate()
                }) {
                    Image(systemName: "chevron.right")
                        .resizable()
                        .frame(width: 10, height: 15)
                        .foregroundColor(colorScheme == .dark ? Color(Theme.primaryDarkMoodColor) : Color(Theme.primaryLightMoodColor))
                }
                .accessibilityLabel("Go to next month")
                .accessibilityAddTraits([.isButton])
            }
        }
    }
    
}
