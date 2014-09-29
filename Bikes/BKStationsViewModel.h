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

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient locationManager:(BKLocationManager *)locationManager;

- (RACSignal *)viewModels:(BOOL)fromSource;

@end
