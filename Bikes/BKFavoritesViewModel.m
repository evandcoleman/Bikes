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
@property (nonatomic) RACCommand *updateCommand;

@end

@implementation BKFavoritesViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient {
    self = [super init];
    if (self != nil) {

        _updateCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            BKLocationManager *locationManager = [[BKLocationManager alloc] init];
            return [[[locationManager.locationSignal
                    take:1]
                    flattenMap:^RACStream *(CLLocation *location) {
                        return [[[[apiClient stationsNearLocation:location]
                                 filter:^BOOL(BKStation *station) {
                                     return (station.status == BKStationStatusInService);
                                 }]
                                 map:^BKStationViewModel *(BKStation *station) {
                                     return [[BKStationViewModel alloc] initWithStation:station openStationCommand:nil];
                                 }] collect];
                    }] deliverOn:[RACScheduler mainThreadScheduler]];
        }];
        
        RAC(self, stationViewModels) = [[_updateCommand executionSignals]
                                        switchToLatest];
    }
    return self;
}

@end
