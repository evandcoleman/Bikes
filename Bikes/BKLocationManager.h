//
//  BKLocationManager.h
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKLocationManager : NSObject

// Sends CLLocation objects
@property (nonatomic, readonly) RACReplaySubject *locationSignal;

@end
