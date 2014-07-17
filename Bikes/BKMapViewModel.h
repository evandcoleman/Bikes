//
//  BKMapViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RVMViewModel.h"

@class BKAPIClient;

@interface BKMapViewModel : RVMViewModel

@property (nonatomic, readonly) NSArray *stationViewModels;

- (instancetype)initWithAPIClient:(BKAPIClient *)client openStationCommand:(RACCommand *)openStationCommand;

@end
