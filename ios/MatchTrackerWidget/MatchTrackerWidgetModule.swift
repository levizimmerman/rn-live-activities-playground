//
//  MatchTrackerWidgetModule.swift
//  FancyTimer
//
//  Created by Levi Zimmerman on 24/06/2024.
//

import Foundation
import ActivityKit

@objc(MatchTrackerWidgetModule)
class MatchTrackerWidgetModule: NSObject {
  
  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  @objc
  func startLiveActivity() -> Void {
    if (!areActivitiesEnabled()) {
      return
    }
    let activityAttributes = MatchTrackerWidgetAttributes()
    let contentState = MatchTrackerWidgetAttributes.ContentState(
      teamAway: "Nederland",
      teamHome: "Griekenland",
      timeStartMatch: Date().addingTimeInterval(-70 * 60),
      pointsTeamAway: 0,
      pointsTeamHome: 2
    )
    let activityContent = ActivityContent(state: contentState, staleDate: nil)
    do {
      try Activity.request(attributes: activityAttributes, content: activityContent)
    } catch {
      
    }
    
  }
  
  @objc
  func stopLiveActivity() -> Void {
    Task {
      for activity in Activity<MatchTrackerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
}
