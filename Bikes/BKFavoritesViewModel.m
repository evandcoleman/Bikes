//
//  BKFavoritesViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKFavoritesViewModel.h"

#import "BKAPIClient.h"
#import "BKLocationManager.h"
#import "BKStationViewModel.h"

@interface BKFavoritesViewModel ()

@property (nonatomic) NSArray *stationViewModels;

@end

@implementation BKFavoritesViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient {
    self = [super init];
    if (self != nil) {
        
        BKLocationManager *locationManager = [[BKLocationManager alloc] init];
        
        RAC(self, stationViewModels) =
            [[[[[RACObserve(self, active)
              ignore:@NO]
              flattenMap:^RACStream *(id _) {
                  return [locationManager.locationSignal take:1];
              }]
              flattenMap:^RACStream *(CLLocation *location) {
                  return [apiClient stationsNearLocation:location];
              }] map:^BKStationViewModel *(BKStation *station) {
                  return [[BKStationViewModel alloc] initWithStation:station openStationCommand:nil];
              }] collect];
    }
    return self;
}

@end
