//
//  BKMapViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKMapViewModel.h"

#import "BKStationViewModel.h"

@interface BKMapViewModel ()

@property (nonatomic) NSArray *stationViewModels;
@property (nonatomic) RACCommand *openStationCommand;

@end

@implementation BKMapViewModel

- (instancetype)initWithStationSignal:(RACSignal *)stationSignal openStationCommand:(RACCommand *)openStationCommand {
    self = [super init];
    if (self != nil) {
        _openStationCommand = openStationCommand;
        
        RAC(self, stationViewModels) = [[stationSignal take:50] collect];
    }
    return self;
}

@end
