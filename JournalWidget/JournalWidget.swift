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

struct IncrementCupIntent: AppIntent {
    
    static var title: LocalizedStringResource = "Add a cup of water"
    static var description = IntentDescription("Increment the number of cup of water")
    var journalViewModel = JournalViewModel()
    
    func perform() async throws -> some IntentResult {
        journalViewModel.addEntry(text: "quick mood:", for: Date(), emoji: "🥲")
        return .result()
    }
}

struct Provider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        
        return SimpleEntry(date: Date(), thought: "what is in your mind?", configuration: ConfigurationAppIntent(), entryCount: entryCount, currentMonth: currentMonth)
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        
        return SimpleEntry(date: Date(), thought: "what is in your mind?", configuration: configuration, entryCount: entryCount, currentMonth: currentMonth)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        
        let entryCount = getCount()
        let currentMonth = getCurrentMonthName()
        
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, thought: "what is in your mind?", configuration: configuration, entryCount: entryCount, currentMonth: currentMonth)
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
        guard let defaults = UserDefaults(suiteName: "group.com.jornal.widget") else {
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
    let configuration: ConfigurationAppIntent
    
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
        
        switch family {
        case .systemSmall:
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
            }
            
        //MARK: System Medium Widget - Leen
        case .systemMedium:
            if !clicked {
                VStack {
                    
                    Text("What is your mood today?").foregroundColor(.white)
                    Text("click the best emoji for your mood today").font(.footnote)
                        .foregroundColor(.white).opacity(0.6)
                    HStack{
                        Button(intent: IncrementCupIntent()) {
                            Text("😃")
                        }
                        Button(intent: IncrementCupIntent()) {
                            Text("😢")
                        }
                        Button(intent: IncrementCupIntent()) {
                            Text("🥳")
                        }
                        Button(intent: IncrementCupIntent()) {
                            Text("😆")
                        }
                        Button(intent: IncrementCupIntent()) {
                            Text("❤️")
                        }
                    }
                    
                }
                .padding()
                .containerBackground(for: .widget) {
                    Theme.primaryLightMoodColor
                }
            } else {
                VStack{
                    Text("Done! 🌟").foregroundColor(.white).font(.title)
                    Text("check it in your journals calender").font(.footnote)
                        .foregroundColor(.white).opacity(0.6)
                }.padding()
                    .containerBackground(for: .widget) {
                        Theme.primaryLightMoodColor
                    }
            }
            
        @unknown default:
            Text("Something went wrong.")
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
        .supportedFamilies([.systemSmall, .systemMedium])
    }
}
