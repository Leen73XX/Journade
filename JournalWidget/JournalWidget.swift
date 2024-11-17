//
//  JournalWidget.swift
//  JournalWidget
//
//  Created by Leen Almejarri on 09/05/1446 AH.
//  Edited by mariyam yasin on 12/05/1446 AH.

import WidgetKit
import SwiftUI
import Intents
import AppIntents



struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        
        return SimpleEntry(date: Date(), thought: "what is in your mind?", entryCount: entryCount, currentMonth: currentMonth)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        
        return SimpleEntry(date: Date(), thought: "what is in your mind?",  entryCount: entryCount, currentMonth: currentMonth)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, thought: "what is in your mind?", entryCount: entryCount, currentMonth: currentMonth)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
    
    // MARK: Journals counter funcs - Mariyam
    func getCurrentMonthName() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: Date())
    }
    
    func getCount() -> Int {
        guard let defaults = UserDefaults(suiteName: "group.jornade.to.store.from.widget") else {
            return 0 }
        
        if let entriesData = defaults.data(forKey: "journalEntries"), let entries = try? JSONDecoder().decode([JournalEntry].self, from: entriesData) {
            
            // Get the current date components for month and year
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
        }
        return 0
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let thought: String

    
    let entryCount: Int
    let currentMonth: String
}

struct JournalWidgetEntryView : View {
    @Environment(\.widgetFamily) var family
    
    var entry: Provider.Entry
    @State private var thought = ""
    @State var clicked = false
    var journalViewModel = JournalViewModel()
    var body: some View {
        
       
       
            //MARK: Journals counter - Mariyam
            VStack {
                Text(entry.currentMonth)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(Color("mainColor"))
                
                // Progress Bar
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.gray.opacity(0.3))
                        .frame(height: 20)
                    
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color("mainColor"))
                        .frame(width: 130 * min(CGFloat(entry.entryCount) / CGFloat(Double(entry.entryCount) * 1.4), 1.0), height: 20)
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
                    .foregroundColor(Color("mainColor"))
            }.containerBackground(for: .widget) {
                Color.white
            }
            
       
            
       
    }
}


struct JournalWidget: Widget {
    let kind: String = "JournalWidget"

    var body: some WidgetConfiguration {
        
        AppIntentConfiguration(kind: kind, provider: Provider()) { entry in
            JournalWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Journal Widget")
        .description("Quickly add thoughts to your journal.")
        .supportedFamilies([.systemSmall])
    }
}
