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
  static let knvbOrange100 = Color(red: 1, green: 0.55, blue: 0)
  static let knvbOrange200 = Color(red: 1, green: 0.49, blue: 0)
  static let knvbOrange300 = Color(red: 0.99, green: 0.42, blue: 0)
  static let knvbOrange700 = Color(red: 1, green: 0.23, blue: 0)
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
        .overlay(Circle().fill(Color.white).opacity(0.5))
    }
    Text(teamName)
      .font(.headline)
      .foregroundColor(.white)
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
      .foregroundColor(.white)
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

struct BottomSlabShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.size.width
    let height = rect.size.height
    path.move(to: CGPoint(x: 0.002*width, y: 0.99738*height))
    path.addLine(to: CGPoint(x: 0.002*width, y: 0.00785*height))
    path.addCurve(to: CGPoint(x: 0.998*width, y: 0.99738*height), control1: CGPoint(x: 0.39022*width, y: -0.04188*height), control2: CGPoint(x: 0.71856*width, y: 0.60995*height))
    path.addLine(to: CGPoint(x: 0.002*width, y: 0.99738*height))
    path.closeSubpath()
    return path
  }
}

struct TopSlabShape: Shape {
  func path(in rect: CGRect) -> Path {
    var path = Path()
    let width = rect.size.width
    let height = rect.size.height
    path.move(to: CGPoint(x: 0.9977*width, y: 0.00364*height))
    path.addLine(to: CGPoint(x: 0.0046*width, y: 0.00364*height))
    path.addCurve(to: CGPoint(x: 0.9977*width, y: 0.99636*height), control1: CGPoint(x: 0.45517*width, y: 0.58364*height), control2: CGPoint(x: 0.3931*width, y: 0.31818*height))
    path.addLine(to: CGPoint(x: 0.9977*width, y: 0.00364*height))
    path.closeSubpath()
    return path
  }
}

struct MatchTrackerWidgetLiveActivity: Widget {
  var body: some WidgetConfiguration {
    ActivityConfiguration(for: MatchTrackerWidgetAttributes.self) { context in
      // Lock screen/banner UI goes here
      ZStack {
        HStack(spacing: 0) {
          ZStack{
            LinearGradient(
              gradient: Gradient(colors: [Color.knvbOrange300, Color.knvbOrange700]),
              startPoint: .top,
              endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            GeometryReader { geometry in
              let height = geometry.size.height
              let offsetY = height * 0.5
              BottomSlabShape()
                .fill(LinearGradient(
                  gradient: Gradient(colors: [Color.knvbOrange100, Color.knvbOrange200]),
                  startPoint: .top,
                  endPoint: .bottom
                ))
                .frame(maxWidth: .infinity, maxHeight: offsetY)
                .offset(y: offsetY)
            }
          }
          ZStack{
            LinearGradient(
              gradient: Gradient(colors: [Color.knvbOrange300, Color.knvbOrange700]),
              startPoint: .bottom,
              endPoint: .top
            )
            .edgesIgnoringSafeArea(.all)
            TopSlabShape()
              .fill(LinearGradient(
                gradient: Gradient(colors: [Color.knvbOrange100, Color.knvbOrange200]),
                startPoint: .bottom,
                endPoint: .top
              ))
              .offset(x: 0, y: -30)
              .frame(maxWidth: .infinity, maxHeight: .infinity)
          }
        }
        HStack {
          // Team home
          VStack{
            TeamView(teamName: context.state.teamHome)
          }
          // Match progress
          VStack(spacing: 0){
            Text("\(context.state.pointsTeamHome) - \(context.state.pointsTeamAway)")
              .font(.title)
              .fontDesign(.monospaced)
              .foregroundColor(.white)
            TimerView(startTime: context.state.timeStartMatch)
          }
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
