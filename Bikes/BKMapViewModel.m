//
//  BKMapViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKMapViewModel.h"

#import "BKStationsViewModel.h"

@interface BKMapViewModel ()

@end

@implementation BKMapViewModel

- (instancetype)initWithStationsViewModel:(BKStationsViewModel *)stationsViewModel {
    self = [super init];
    if (self != nil) {
        _stationsViewModel = stationsViewModel;
    }
    return self;
}

@end
