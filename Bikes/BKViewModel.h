//
//  BKViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 10/8/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RVMViewModel.h"

@class BKErrorViewModel;

@interface BKViewModel : RVMViewModel

@property (nonatomic, readonly) RACSubject *errorViewModels;

@end
