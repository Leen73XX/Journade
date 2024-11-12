//
//  JournalWidget.swift
//  JournalWidget
//
//  Created by Leen Almejarri on 09/05/1446 AH.
//

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
        SimpleEntry(date: Date(), thought: "what is in your mind?", configuration: ConfigurationAppIntent())
    }

    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
        SimpleEntry(date: Date(), thought: "what is in your mind?", configuration: configuration)
    }
    
    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
        var entries: [SimpleEntry] = []

        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = SimpleEntry(date: entryDate, thought: "what is in your mind?", configuration: configuration)
            entries.append(entry)
        }

        return Timeline(entries: entries, policy: .atEnd)
    }
}
struct SimpleEntry: TimelineEntry {
    let date: Date
    let thought: String
    let configuration: ConfigurationAppIntent
}

struct JournalWidgetEntryView : View {
    var entry: Provider.Entry
     @State private var thought = ""
    @State var clicked = false
    var journalViewModel = JournalViewModel()
     var body: some View {
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
        .supportedFamilies([.systemMedium])
    }
}
