//
//  BKNotificationsController.m
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKNotificationsController.h"

typedef NS_ENUM(NSUInteger, BKNotificationType) {
    BKNotificationTypeStationStatus,
};

NSString * const NotificationIdentifierKey = @"NotificationIdentifierKey";

@implementation BKNotificationsController

+ (RACSignal *)scheduledNotifications {
    return [[[UIApplication sharedApplication] scheduledLocalNotifications].rac_sequence
        filter:^BOOL(UILocalNotification *note) {
            return [note.userInfo[NotificationIdentifierKey] isEqualToNumber:@(BKNotificationTypeStationStatus)];
        }].signal;
}

+ (RACSignal *)scheduleNotificationForDate:(NSDate *)date repeatInterval:(NSCalendarUnit)interval station:(BKStation *)station {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.fireDate = date;
        notification.repeatInterval = interval;
        notification.repeatCalendar = [NSCalendar currentCalendar];
        notification.timeZone = [NSTimeZone localTimeZone];
        
        
        return nil;
    }];
}

@end
