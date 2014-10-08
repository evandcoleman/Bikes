//
//  BKStationsController.h
//  Bikes
//
//  Created by Evan Coleman on 10/7/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

typedef NS_ENUM(NSUInteger, DataFetchPolicy) {
    DataFetchPolicyDefault = 0,
    DataFetchPolicyCacheOnly,
    DataFetchPolicySourceOnly,
    DataFetchPolicyCacheFirst,
};

@class BKAPIClient;
@class BKAPICacheClient;

@interface BKStationsController : NSObject

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient cacheClient:(BKAPICacheClient *)cacheClient;

- (RACSignal *)readStations:(DataFetchPolicy)policy;

@end
