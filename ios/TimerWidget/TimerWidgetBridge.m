//
//  TimerWidgetBridge.m
//  FancyTimer
//
//  Created by Levi Zimmerman on 05/06/2024.
//

#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(TimerWidgetModule, NSObject)

// The requiresMainQueueSetup method informs React Native whether your module needs to be initialized on the main thread prior to the execution of any JavaScript code.
+ (bool) requiresMainQueueSetup {
  return NO;
}

RCT_EXTERN_METHOD(startLiveActivity)
RCT_EXTERN_METHOD(stopLiveActivity)

@end
