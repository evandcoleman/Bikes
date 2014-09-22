//
//  BKStationsViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 9/21/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationsViewModel.h"

#import "BKAPIClient.h"
#import "BKLocationManager.h"

#import "BKStationViewModel.h"

@implementation BKStationsViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient locationManager:(BKLocationManager *)locationManager {
    self = [super init];
    if (self != nil) {
        _loadStationsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            [apiClient clearCache];
            return [[[[RACSignal combineLatest:@[ [apiClient readStations], [locationManager.locationSignal take:1] ]]
                        distinctUntilChanged]
                        flattenMap:^RACSignal *(RACTuple *t) {
                            RACTupleUnpack(NSArray *stations, CLLocation *location) = t;
                            return [[[stations.rac_sequence
                                        map:^BKStationViewModel *(BKStation *station) {
                                            CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                                            CGFloat distance = [stationLocation distanceFromLocation:location];
                                            station.distance = distance;
                                            
                                            BKStationViewModel *viewModel = [[BKStationViewModel alloc] initWithStation:station];
                                            return viewModel;
                                        }]
                                        signal]
                                        collect];
                        }]
                        map:^NSArray *(NSArray *stationViewModels) {
                            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
                            return [stationViewModels sortedArrayUsingDescriptors:@[sortDescriptor]];
                        }];
        }];
        
        RAC(self, viewModels) =
            [[[[_loadStationsCommand executionSignals]
                switchToLatest]
                ignore:nil]
                deliverOn:[RACScheduler mainThreadScheduler]];
    }
    return self;
}

@end
