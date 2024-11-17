//
//  journadeWidget.swift
//  journadeWidget
//
//  Created by Leen Almejarri on 15/05/1446 AH.
//

import WidgetKit
import SwiftUI


// Timeline Entry
struct SimpleEntry: TimelineEntry {
    let date: Date
    let thought: String
    let entryCount: Int
    let currentMonth: String
}

// Provider for Timeline Entries
struct Provider: TimelineProvider {
    
    // Placeholder for when the widget is loading
    func placeholder(in context: Context) -> SimpleEntry {
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        return SimpleEntry(date: Date(), thought: "What is on your mind?", entryCount: entryCount, currentMonth: currentMonth)
    }
    
    // Snapshot for when the widget is first rendered (using completion handler)
    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        let snapshot = SimpleEntry(date: Date(), thought: "What is on your mind?", entryCount: entryCount, currentMonth: currentMonth)
        completion(snapshot)
    }

    // Timeline for the widget, providing multiple entries to be shown over time (using completion handler)
    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        var entries: [SimpleEntry] = []
        let currentDate = Date()

        // Call getCount() to fetch the updated count
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()

        // Generate entries for the next 5 hours
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, thought: "What is in your mind?", entryCount: entryCount, currentMonth: currentMonth)
            entries.append(entry)
        }

        // Set the reload policy to trigger after 30 minutes or any other time interval
        let reloadTime = Calendar.current.date(byAdding: .second, value: 1, to: currentDate)!

        // Create and return the timeline with the updated entries and a refresh policy
        let timeline = Timeline(entries: entries, policy: .after(reloadTime))
        completion(timeline)
    }


    // Helper functions
    func getCurrentMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }

    func getCount() -> Int {
        guard let defaults = UserDefaults(suiteName: "group.jornade.to.store.from.widget") else {
            print("Error: Unable to access UserDefaults suite")
            return 0
        }

        guard let entriesData = defaults.data(forKey: "journalEntries") else {
            print("No journal entries data found in UserDefaults")
            return 0
        }

        do {
            let entries = try JSONDecoder().decode([JournalEntry].self, from: entriesData)
            
            // Get the current month and year
            let calendar = Calendar.current
            let currentMonth = calendar.component(.month, from: Date())
            let currentYear = calendar.component(.year, from: Date())

            // Filter entries for the current month and year
            let currentMonthEntries = entries.filter { entry in
                let entryMonth = calendar.component(.month, from: entry.date)
                let entryYear = calendar.component(.year, from: entry.date)
                return entryMonth == currentMonth && entryYear == currentYear
            }

            return currentMonthEntries.count
        } catch {
            print("Failed to decode journal entries: \(error.localizedDescription)")
            return 0
        }
    }

}

// Widget View
struct JournadeWidgetEntryView: View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack {
            Text(entry.currentMonth)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryLightMoodColor)
            
            // Progress Bar
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 20)
                
                RoundedRectangle(cornerRadius: 10)
                    .fill(Theme.primaryLightMoodColor)
                    .frame(width: 130 * min(CGFloat(entry.entryCount) / CGFloat(1.4), 1.0), height: 20)
                    .overlay(
                        HStack {
                            Spacer()
                            Text("\(entry.entryCount)")
                                .foregroundColor(.white)
                                .font(.subheadline)
                                .padding(.horizontal, 5)
                        }
                    )
            }
            .frame(width: 130)
            .padding()
            
            Text("Journaling Times")
                .font(.caption)
                .fontWeight(.bold)
                .foregroundColor(Theme.primaryLightMoodColor)
        }
        .containerBackground(for: .widget) {
            Color.white
        }
    }
}

// Widget Configuration
struct JournadeWidget: Widget {
    let kind: String = "JournadeWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            JournadeWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Journaling Widget")
        .description("Quickly track your journaling progress.")
        .supportedFamilies([.systemSmall])
    }
}


