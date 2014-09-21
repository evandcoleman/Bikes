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

@property (nonatomic) NSArray *nearbyStationViewModels;
@property (nonatomic) NSArray *favoriteStationViewModels;
@property (nonatomic) RACCommand *updateNearbyCommand;
@property (nonatomic) RACCommand *updateFavoritesCommand;
@property (nonatomic) RACCommand *refreshCommand;

@property (nonatomic) BKLocationManager *locationManager;

@end

@implementation BKFavoritesViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient {
    self = [super init];
    if (self != nil) {

        _locationManager = [[BKLocationManager alloc] init];
        
        @weakify(self);
        _updateNearbyCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [[[self.locationManager.locationSignal
                    take:1]
                    flattenMap:^RACStream *(CLLocation *location) {
                        return [[[[[apiClient stationsNearLocation:location]
                                 filter:^BOOL(BKStation *station) {
                                     return ((station.status == BKStationStatusInService) && !station.isFavorite);
                                 }]
                                 map:^BKStationViewModel *(BKStation *station) {
                                     return [[BKStationViewModel alloc] initWithStation:station openStationCommand:nil];
                                 }] collect] map:^id(NSArray *stationViewModels) {
                                     NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
                                     return [stationViewModels sortedArrayUsingDescriptors:@[sortDescriptor]];
                                 }];
                    }] deliverOn:[RACScheduler mainThreadScheduler]];
        }];
        
        _updateFavoritesCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            return [[[[[[apiClient cachedStations]
                        flattenMap:^RACStream *(NSArray *stations) {
                            return stations.rac_sequence.signal;
                        }]
                        filter:^BOOL(BKStation *station) {
                            return station.isFavorite;
                        }] map:^BKStationViewModel *(BKStation *station) {
                            return [[BKStationViewModel alloc] initWithStation:station openStationCommand:nil];
                        }] collect] deliverOn:[RACScheduler mainThreadScheduler]];
        }];

        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [RACSignal combineLatest:@[ [self.updateFavoritesCommand execute:nil], [self.updateNearbyCommand execute:nil] ]];
        }];

        [[[_updateNearbyCommand executionSignals]
            switchToLatest] subscribeNext:^(NSArray *stationViewModels) {
                @strongify(self);
                self.nearbyStationViewModels = stationViewModels;
            }];

        [[[_updateFavoritesCommand executionSignals]
              switchToLatest] subscribeNext:^(NSArray *stationViewModels) {
                @strongify(self);
                self.favoriteStationViewModels = stationViewModels;
            }];
    }
    return self;
}

@end
