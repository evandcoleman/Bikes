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

@property (nonatomic, readonly) BKStationsViewModel *stationsViewModel;

@end

@implementation BKFavoritesViewModel

- (instancetype)initWithStationsViewModel:(BKStationsViewModel *)stationsViewModel {
    self = [super init];
    if (self != nil) {
        _stationsViewModel = stationsViewModel;
        
        @weakify(self);
        _refreshCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.stationsViewModel.refreshStationsCommand execute:nil];
        }];
        
        [[[self didBecomeActiveSignal]
            flattenMap:^RACSignal *(id _) {
                @strongify(self);
                return [self.stationsViewModel.loadStationsCommand execute:nil];
            }]
            subscribeNext:^(id _) {
                
            }];
        
        RAC(self, nearbyStationViewModels) =
            [[RACObserve(self.stationsViewModel, viewModels)
                map:^NSArray *(NSArray *viewModels) {
                    return [[viewModels.rac_sequence
                                filter:^BOOL(BKStationViewModel *viewModel) {
                                    return viewModel.station.distance < 800 && !viewModel.favorite;
                                }]
                                array];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];
        
        RAC(self, favoriteStationViewModels) =
            [[RACObserve(self.stationsViewModel, viewModels)
                map:^NSArray *(NSArray *viewModels) {
                    return [[viewModels.rac_sequence
                                filter:^BOOL(BKStationViewModel *viewModel) {
                                    return viewModel.station.favorite;
                                }]
                                array];
                }]
                deliverOn:[RACScheduler mainThreadScheduler]];
    }
    return self;
}

@end
