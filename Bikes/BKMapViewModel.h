//
//  BKMapViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RVMViewModel.h"

@interface BKMapViewModel : RVMViewModel

@property (nonatomic, readonly) NSArray *stationViewModels;

- (instancetype)initWithStationSignal:(RACSignal *)stationSignal openStationCommand:(RACCommand *)openStationCommand;

@end
