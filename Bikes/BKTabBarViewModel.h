//
//  BKTabBarViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RVMViewModel.h"

@class BKStationsViewModel;

@interface BKTabBarViewModel : RVMViewModel

@property (nonatomic, readonly) BKStationsViewModel *stationsViewModel;

@end
