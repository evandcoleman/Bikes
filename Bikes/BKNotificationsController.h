//
//  BKNotificationsController.h
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BKStation;

@interface BKNotificationsController : NSObject

+ (RACSignal *)scheduledNotifications;
+ (RACSignal *)scheduleNotificationForDate:(NSDate *)date repeatInterval:(NSCalendarUnit)interval station:(BKStation *)station;

@end
