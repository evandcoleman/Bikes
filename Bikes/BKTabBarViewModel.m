//
//  BKTabBarViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKTabBarViewModel.h"

#import "BKTabBarModel.h"
#import "BKStationViewModel.h"
#import "BKStation.h"

@interface BKTabBarViewModel ()

@property (nonatomic) BKTabBarModel *tabBarModel;
@property (nonatomic) RACSignal *presentViewModelSignal;
@property (nonatomic) RACCommand *openViewModelCommand;
@property (nonatomic) NSArray *stationViewModels;

@end

@implementation BKTabBarViewModel

- (instancetype)initWithTabBarModel:(BKTabBarModel *)tabBarModel {
    self = [super init];
    if (self != nil) {
        _tabBarModel = tabBarModel;
        
        _openViewModelCommand = [[RACCommand alloc] initWithEnabled:RACObserve(self, active) signalBlock:^RACSignal *(RVMViewModel *viewModel) {
            return [RACSignal return:viewModel];
        }];
        
        _presentViewModelSignal = [[_openViewModelCommand executionSignals]
                                       switchToLatest];
        
        RAC(self, stationViewModels) = [[RACObserve(self.tabBarModel, stations) ignore:nil] map:^BKStationViewModel *(BKStation *station) {
            return [[BKStationViewModel alloc] initWithStation:station openStationCommand:_openViewModelCommand];
        }];
    }
    return self;
}

@end
