//
//  BKTabBarViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKTabBarViewModel.h"

#import "BKAPIClient.h"
#import "BKStation.h"

@interface BKTabBarViewModel ()

@property (nonatomic) BKAPIClient *apiClient;
@property (nonatomic) RACSignal *presentViewModelSignal;
@property (nonatomic) RACCommand *openViewModelCommand;

@end

@implementation BKTabBarViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)client {
    self = [super init];
    if (self != nil) {
        _apiClient = client;
        
        _openViewModelCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(RVMViewModel *viewModel) {
            return [RACSignal return:viewModel];
        }];
        
        _presentViewModelSignal = [[_openViewModelCommand executionSignals]
                                       switchToLatest];
    }
    return self;
}

@end
