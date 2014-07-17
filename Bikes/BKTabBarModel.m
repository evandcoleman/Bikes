//
//  BKTabBarModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKTabBarModel.h"

#import "BKAPIClient.h"
#import "BKTabBarViewModel.h"

@interface BKTabBarModel ()

@property (nonatomic) BKAPIClient *apiClient;
@property (nonatomic) NSArray *stations;

@end

@implementation BKTabBarModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _apiClient = [[BKAPIClient alloc] init];
        
        RAC(self, stations) = _apiClient.stationsSignal;
    }
    return self;
}

@end
