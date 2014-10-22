//
//  BKStationsViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 9/21/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationsViewModel.h"

#import "BKStationsController.h"

#import "BKStationViewModel.h"
#import "BKErrorViewModel.h"

@interface BKStationsViewModel ()

@end

@implementation BKStationsViewModel

- (instancetype)initWithStationsController:(BKStationsController *)stationsController {
    self = [super init];
    if (self != nil) {
        @weakify(self);
        _loadStationsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *dataFetchPolicy) {
            DataFetchPolicy policy = DataFetchPolicyCacheFirst;
            if (dataFetchPolicy != nil) {
                policy = [dataFetchPolicy unsignedIntegerValue];
            }
            
            return [[[[stationsController readStations:policy]
                        map:^NSArray *(NSArray *stations) {
                            return [[stations.rac_sequence
                                        map:^BKStationViewModel *(BKStation *station) {
                                            return [[BKStationViewModel alloc] initWithStation:station];
                                        }]
                                        array];
                        }]
                        map:^NSArray *(NSArray *viewModels) {
                            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
                            return [viewModels sortedArrayUsingDescriptors:@[sortDescriptor]];
                        }]
                        timeout:10 onScheduler:RACScheduler.scheduler];
        }];
        
        _refreshStationsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            @strongify(self);
            return [self.loadStationsCommand execute:@(DataFetchPolicySourceOnly)];
        }];
        
        _favoriteStationCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RACTuple *t) {
            RACTupleUnpack(BKStationViewModel *viewModel, NSNumber *favorite) = t;
            [self willChangeValueForKey:@keypath(self.viewModels)];
            viewModel.favorite = [favorite boolValue];
            return [RACSignal return:viewModel];
        }];
        
        [[[_favoriteStationCommand executionSignals]
            switchToLatest]
            subscribeNext:^(id _) {
                @strongify(self);
                [self didChangeValueForKey:@keypath(self.viewModels)];
            }];
        
        RAC(self, viewModels) =
            [[[_loadStationsCommand executionSignals]
                switchToLatest]
                ignore:nil];
    }
    return self;
}

@end
