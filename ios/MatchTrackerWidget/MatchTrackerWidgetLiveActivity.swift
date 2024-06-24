//
//  MatchTrackerWidgetLiveActivity.swift
//  MatchTrackerWidget
//
//  Created by Levi Zimmerman on 12/06/2024.
//

import ActivityKit
import WidgetKit
import SwiftUI
import Combine

extension Color {
  static let knvbOrange = Color(red: 0.99, green: 0.42, blue: 0)
}

struct MatchTrackerWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
      var teamAway: String
      var teamHome: String
      var timeStartMatch: Date
      var pointsTeamAway: Int
      var pointsTeamHome: Int
    }
}

struct TeamView: View {
  var teamName: String
  var teamImage: String?
  
  var body: some View {
    VStack {
      Image(teamImage ?? "")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .frame(width: 40, height: 40)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
        .overlay(Circle().fill(Color.gray))
    }
    Text(teamName)
      .font(.headline)
      .foregroundColor(.primary)
      .padding(.top, 10)
  }
  
}

struct TimerView: View {
    let startTime: Date
    @State private var currentTime: Date = Date()
    
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(timeString(from: elapsedSeconds))
            .fontDesign(.monospaced)
            .font(.title3)
            .padding(.top, 5)
            .onAppear {
                // Timer automatically starts with autoconnect
            }
            .onDisappear {
                // Timer will stop receiving updates when the view disappears
            }
            .onReceive(timer) { time in
                currentTime = time
            }
    }

    private var elapsedSeconds: TimeInterval {
        return currentTime.timeIntervalSince(startTime)
    }
    
    private func timeString(from elapsed: TimeInterval) -> String {
        let minutes = Int(elapsed) / 60
        let seconds = Int(elapsed) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
}

struct TimerView_Previews: PreviewProvider {
    static var previews: some View {
        TimerView(startTime: Date().addingTimeInterval(-120))
    }
}

struct MatchTrackerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MatchTrackerWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
          ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.knvbOrange, Color.blue]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            HStack {
              // Team home
              VStack{
                TeamView(teamName: context.state.teamHome)
              }
              // Match progress
              VStack{
                Text("\(context.state.pointsTeamHome) - \(context.state.pointsTeamAway)")
                  .font(.title)
                  .fontDesign(.monospaced)
                TimerView(startTime: context.state.timeStartMatch)
              }
              .padding(.horizontal, 10)
              // Team away
              VStack{
                TeamView(teamName: context.state.teamAway)
              }
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 30)
          }
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
                    Text("Bottom")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T")
            } minimal: {
                Text("\(context.state.pointsTeamHome)-\(context.state.pointsTeamAway)")
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MatchTrackerWidgetAttributes {
    fileprivate static var preview: MatchTrackerWidgetAttributes {
        MatchTrackerWidgetAttributes()
    }
}

extension MatchTrackerWidgetAttributes.ContentState {
    fileprivate static var smiley: MatchTrackerWidgetAttributes.ContentState {
      MatchTrackerWidgetAttributes.ContentState(
        teamAway: "Nederland",
        teamHome: "Griekenland",
        timeStartMatch: Date().addingTimeInterval(-50 * 60),
        pointsTeamAway: 1,
        pointsTeamHome: 0
      )
     }
     
     fileprivate static var starEyes: MatchTrackerWidgetAttributes.ContentState {
         MatchTrackerWidgetAttributes.ContentState(
          teamAway: "Nederland",
          teamHome: "Griekenland",
          timeStartMatch: Date().addingTimeInterval(-70 * 60),
          pointsTeamAway: 3,
          pointsTeamHome: 1
         )
     }
}

#Preview("Notification", as: .content, using: MatchTrackerWidgetAttributes.preview) {
   MatchTrackerWidgetLiveActivity()
} contentStates: {
    MatchTrackerWidgetAttributes.ContentState.smiley
    MatchTrackerWidgetAttributes.ContentState.starEyes
}
