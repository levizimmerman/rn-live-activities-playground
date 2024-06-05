//
//  TimerWidgetModule.swift
//  FancyTimer
//
//  Created by Levi Zimmerman on 05/06/2024.
//

import Foundation
import ActivityKit

@objc(TimerWidgetModule)
class TimerWidgetModule: NSObject {
  
  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  @objc
  func startLiveActivity() -> Void {
    if (!areActivitiesEnabled()) {
      return
    }
    
    let activityAttributes = TimerWidgetAttributes()
    let contentState = TimerWidgetAttributes.ContentState(startedAt: Date())
    let activityContent = ActivityContent(state: contentState, staleDate: nil)
    do {
      try Activity.request(attributes: activityAttributes, content: activityContent)
    } catch {
      // Handle errors
    }
  }
  
  @objc
  func stopLiveActivity() -> Void {
    Task {
      for activity in Activity<TimerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
}
