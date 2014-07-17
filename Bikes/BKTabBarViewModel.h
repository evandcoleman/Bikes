//
//  BKTabBarViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RVMViewModel.h"

@class BKAPIClient;

@interface BKTabBarViewModel : RVMViewModel

@property (nonatomic, readonly) RACSignal *presentViewModelSignal;

@property (nonatomic, readonly) RACCommand *openViewModelCommand;

@property (nonatomic, readonly) BKAPIClient *apiClient;

- (instancetype)initWithAPIClient:(BKAPIClient *)client;

@end
