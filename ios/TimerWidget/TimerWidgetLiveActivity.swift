//
//  TimerWidgetLiveActivity.swift
//  TimerWidget
//
//  Created by Levi Zimmerman on 29/05/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct TimerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
      var startedAt: Date?
      
      func getTimeIntervalSinceNow() -> Double {
        guard let startedAt = self.startedAt else {
          return 0
        }
        return startedAt.timeIntervalSince1970 - Date().timeIntervalSince1970
      }
    }
}

struct TimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: TimerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
              Text(
                Date(timeIntervalSinceNow: context.state.getTimeIntervalSinceNow()),
                style: .timer
              )
              .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
              .fontWeight(.medium)
              .monospacedDigit()
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
              DynamicIslandExpandedRegion(.center) {
                Text(
                  Date(timeIntervalSinceNow: context.state.getTimeIntervalSinceNow()),
                  style: .timer
                )
                .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
                .foregroundColor(.cyan)
                .fontWeight(.medium)
                .monospacedDigit()
              }
            } compactLeading: {
              Image(systemName: "timer")
                .imageScale(.medium)
                .foregroundColor(.cyan)
            } compactTrailing: {
                Text(
                  Date(timeIntervalSinceNow: context.state.getTimeIntervalSinceNow()),
                  style: .timer
                )
                .foregroundColor(.cyan)
                .frame(maxWidth: 32)
                .monospacedDigit()
            } minimal: {
              Image(systemName: "timer")
                .imageScale(.medium)
                .foregroundColor(.cyan)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension TimerWidgetAttributes {
    fileprivate static var preview: TimerWidgetAttributes {
        TimerWidgetAttributes()
    }
}

extension TimerWidgetAttributes.ContentState {
    fileprivate static var initState: TimerWidgetAttributes.ContentState {
        TimerWidgetAttributes.ContentState(startedAt: Date())
     }
}

#Preview("Notification", as: .content, using: TimerWidgetAttributes.preview) {
   TimerWidgetLiveActivity()
} contentStates: {
    TimerWidgetAttributes.ContentState.initState
}
