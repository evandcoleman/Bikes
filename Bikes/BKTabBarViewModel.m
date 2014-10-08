//
//  BKTabBarViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKTabBarViewModel.h"

#import "BKAPIClient.h"
#import "BKAPICacheClient.h"
#import "BKStationsController.h"

#import "BKStationsViewModel.h"

@interface BKTabBarViewModel ()

@end

@implementation BKTabBarViewModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        BKAPIClient *apiClient = [[BKAPIClient alloc] init];
        BKAPICacheClient *cacheClient = [[BKAPICacheClient alloc] init];
        
        BKStationsController *stationsController = [[BKStationsController alloc] initWithAPIClient:apiClient cacheClient:cacheClient];
        
        _stationsViewModel = [[BKStationsViewModel alloc] initWithStationsController:stationsController];
    }
    return self;
}

@end
