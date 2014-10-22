//
//  BKStationViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewModel.h"

#import <MapKit/MapKit.h>

@class BKStation;

@interface BKStationViewModel : BKViewModel <MKAnnotation>

@property (nonatomic, readonly) BKStation *station;

@property (nonatomic, readonly) NSString *name;
@property (nonatomic, readonly) NSString *status;
@property (nonatomic, readonly) NSString *availableDocks;
@property (nonatomic, readonly) NSString *availableBikes;
@property (nonatomic, readonly) CGFloat fillPercentage;
@property (nonatomic, readonly) UIColor *statusColor;
@property (nonatomic, readonly) NSString *distance;
@property (nonatomic, readonly) NSString *lastUpdated;
@property (nonatomic, getter = isFavorite) BOOL favorite;

- (instancetype)initWithStation:(BKStation *)station;

@end
