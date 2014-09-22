//
//  BKFavoritesViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKFavoritesViewModel.h"

#import "BKStationsViewModel.h"
#import "BKStationViewModel.h"

#import "BKStation.h"

@interface BKFavoritesViewModel ()

@end

@implementation BKFavoritesViewModel

- (instancetype)initWithStationsViewModel:(BKStationsViewModel *)stationsViewModel {
    self = [super init];
    if (self != nil) {
        
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            return [stationsViewModel.loadStationsCommand execute:nil];
        }];
        
        RAC(self, nearbyStationViewModels) =
            [[[[_refreshCommand executionSignals]
                switchToLatest]
                flattenMap:^RACSignal *(NSArray *viewModels) {
                    return [[[viewModels.rac_sequence
                                filter:^BOOL(BKStationViewModel *viewModel) {
                                    return viewModel.station.distance < 800;
                                }]
                                signal]
                                collect];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];
        
        RAC(self, favoriteStationViewModels) =
            [[[[_refreshCommand executionSignals]
                switchToLatest]
                flattenMap:^RACSignal *(NSArray *viewModels) {
                    return [[[viewModels.rac_sequence
                                filter:^BOOL(BKStationViewModel *viewModel) {
                                    return viewModel.station.favorite;
                                }]
                                signal]
                                collect];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];
    }
    return self;
}

@end
