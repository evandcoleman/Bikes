//
//  BKMapViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKMapViewModel.h"

#import "BKAPIClient.h"
#import "BKStationViewModel.h"

@interface BKMapViewModel ()

@property (nonatomic) NSArray *stationViewModels;
@property (nonatomic) RACCommand *openStationCommand;

@end

@implementation BKMapViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)client openStationCommand:(RACCommand *)openStationCommand {
    self = [super init];
    if (self != nil) {
        _openStationCommand = openStationCommand;
        
        RAC(self, stationViewModels) = [[client fetchStations] map:^BKStationViewModel *(BKStation *station) {
            return [[BKStationViewModel alloc] initWithStation:station openStationCommand:_openStationCommand];
        }];
    }
    return self;
}

@end
