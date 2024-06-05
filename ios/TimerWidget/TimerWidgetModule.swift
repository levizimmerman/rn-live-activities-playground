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
  private var startedAt: Date?
  
  private func areActivitiesEnabled() -> Bool {
    return ActivityAuthorizationInfo().areActivitiesEnabled
  }
  
  @objc
  func startLiveActivity(_ timestamp: Double) -> Void {
    startedAt = Date(timeIntervalSince1970:  timestamp)
    if (!areActivitiesEnabled()) {
      return
    }
    
    let activityAttributes = TimerWidgetAttributes()
    let contentState = TimerWidgetAttributes.ContentState(startedAt: startedAt)
    let activityContent = ActivityContent(state: contentState, staleDate: nil)
    do {
      try Activity.request(attributes: activityAttributes, content: activityContent)
    } catch {
      // Handle errors
    }
  }
  
  @objc
  func stopLiveActivity() -> Void {
    startedAt = nil
    Task {
      for activity in Activity<TimerWidgetAttributes>.activities {
        await activity.end(nil, dismissalPolicy: .immediate)
      }
    }
  }
}
