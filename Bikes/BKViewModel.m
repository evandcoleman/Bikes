//
//  BKViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 10/8/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewModel.h"

#import "BKErrorViewModel.h"

@implementation BKViewModel

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _errorViewModels = [RACSubject subject];
    }
    return self;
}

- (void)dealloc {
    [self.errorViewModels sendCompleted];
}

@end
