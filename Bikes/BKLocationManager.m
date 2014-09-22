//
//  BKLocationManager.m
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKLocationManager.h"

#import <CoreLocation/CoreLocation.h>

@interface BKLocationManager () <CLLocationManagerDelegate>

@property (nonatomic) CLLocationManager *manager;

@end

@implementation BKLocationManager

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _manager = [[CLLocationManager alloc] init];
        _manager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        _manager.delegate = self;
        
        _locationSignal = [RACReplaySubject replaySubjectWithCapacity:1];
        
        [[[[self rac_signalForSelector:@selector(locationManager:didUpdateLocations:) fromProtocol:@protocol(CLLocationManagerDelegate)]
            reduceEach:^id(__unused CLLocationManager *_, NSArray *locations) {
                return locations;
            }]
            map:^id(NSArray *locations) {
                return [locations lastObject];
            }]
            subscribe:_locationSignal];
        
        [_manager requestWhenInUseAuthorization];
        [_manager startUpdatingLocation];
    }
    return self;
}

@end
