//
//  MatchTrackerWidgetLiveActivity.swift
//  MatchTrackerWidget
//
//  Created by Levi Zimmerman on 12/06/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MatchTrackerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MatchTrackerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchTrackerWidgetAttributes.self) { context in
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

extension MatchTrackerWidgetAttributes {
    fileprivate static var preview: MatchTrackerWidgetAttributes {
        MatchTrackerWidgetAttributes(name: "World")
    }
}

extension MatchTrackerWidgetAttributes.ContentState {
    fileprivate static var smiley: MatchTrackerWidgetAttributes.ContentState {
        MatchTrackerWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MatchTrackerWidgetAttributes.ContentState {
         MatchTrackerWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MatchTrackerWidgetAttributes.preview) {
   MatchTrackerWidgetLiveActivity()
} contentStates: {
    MatchTrackerWidgetAttributes.ContentState.smiley
    MatchTrackerWidgetAttributes.ContentState.starEyes
}
