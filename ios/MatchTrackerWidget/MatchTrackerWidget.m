//
//  MatchTrackerWidget.m
//  FancyTimer
//
//  Created by Levi Zimmerman on 24/06/2024.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(MatchTrackerWidgetModule, NSObject)

+ (bool)requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(startLiveActivity)
RCT_EXTERN_METHOD(stopLiveActivity)

@end
