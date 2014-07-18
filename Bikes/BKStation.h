//
//  BKStation.h
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Mantle/Mantle.h>

typedef NS_ENUM(NSUInteger, BKStationStatus) {
    BKStationStatusUnknown,
    BKStationStatusInService,
    BKStationStatusOutOfService,
};

@interface BKStation : MTLModel <MTLJSONSerializing>

@property (nonatomic) NSInteger stationID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSInteger availableDocks;
@property (nonatomic) NSInteger availableBikes;
@property (nonatomic) NSInteger totalDocks;
@property (nonatomic) CGFloat latitude;
@property (nonatomic) CGFloat longitude;
@property (nonatomic) BKStationStatus status;
@property (nonatomic) NSString *statusValue;
@property (nonatomic) NSDate *lastUpdated;
@property (nonatomic, getter = isFavorite) BOOL favorite;

@end
