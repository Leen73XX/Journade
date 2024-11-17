//
//  journadeWidgetLiveActivity.swift
//  journadeWidget
//
//  Created by Leen Almejarri on 15/05/1446 AH.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct journadeWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct journadeWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: journadeWidgetAttributes.self) { context in
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

extension journadeWidgetAttributes {
    fileprivate static var preview: journadeWidgetAttributes {
        journadeWidgetAttributes(name: "World")
    }
}

extension journadeWidgetAttributes.ContentState {
    fileprivate static var smiley: journadeWidgetAttributes.ContentState {
        journadeWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: journadeWidgetAttributes.ContentState {
         journadeWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: journadeWidgetAttributes.preview) {
   journadeWidgetLiveActivity()
} contentStates: {
    journadeWidgetAttributes.ContentState.smiley
    journadeWidgetAttributes.ContentState.starEyes
}
