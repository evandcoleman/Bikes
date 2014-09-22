//
//  BKStationsViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 9/21/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "RVMViewModel.h"

@class BKAPIClient;
@class BKLocationManager;

@interface BKStationsViewModel : RVMViewModel

@property (nonatomic, readonly) NSArray *viewModels;

@property (nonatomic, readonly) RACCommand *loadStationsCommand;

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient locationManager:(BKLocationManager *)locationManager;

@end
