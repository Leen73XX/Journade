//
//  JournalWidgetLiveActivity.swift
//  JournalWidget
//
//  Created by Leen Almejarri on 09/05/1446 AH.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct JournalWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct JournalWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: JournalWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension JournalWidgetAttributes {
    fileprivate static var preview: JournalWidgetAttributes {
        JournalWidgetAttributes(name: "World")
    }
}

extension JournalWidgetAttributes.ContentState {
    fileprivate static var smiley: JournalWidgetAttributes.ContentState {
        JournalWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: JournalWidgetAttributes.ContentState {
         JournalWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: JournalWidgetAttributes.preview) {
   JournalWidgetLiveActivity()
} contentStates: {
    JournalWidgetAttributes.ContentState.smiley
    JournalWidgetAttributes.ContentState.starEyes
}
