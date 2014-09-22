//
//  BKTabBarViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKTabBarViewModel.h"

#import "BKAPIClient.h"
#import "BKLocationManager.h"

#import "BKStationsViewModel.h"

@interface BKTabBarViewModel ()

@end

@implementation BKTabBarViewModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        BKAPIClient *apiClient = [[BKAPIClient alloc] init];
        BKLocationManager *locationManager = [[BKLocationManager alloc] init];
        
        _stationsViewModel = [[BKStationsViewModel alloc] initWithAPIClient:apiClient locationManager:locationManager];
    }
    return self;
}

@end
