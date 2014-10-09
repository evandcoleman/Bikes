//
//  BKMapViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewModel.h"

@class BKStationsViewModel;

@interface BKMapViewModel : BKViewModel

@property (nonatomic, readonly) BKStationsViewModel *stationsViewModel;

- (instancetype)initWithStationsViewModel:(BKStationsViewModel *)stationsViewModel;

@end
