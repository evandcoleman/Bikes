//
//  BKStationsController.m
//  Bikes
//
//  Created by Evan Coleman on 10/7/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationsController.h"

#import "BKAPIClient.h"
#import "BKAPICacheClient.h"

@interface BKStationsController ()

@property (nonatomic) BKAPIClient *apiClient;
@property (nonatomic) BKAPICacheClient *cacheClient;

@end

@implementation BKStationsController

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient cacheClient:(BKAPICacheClient *)cacheClient {
    self = [super init];
    if (self != nil) {
        _apiClient = apiClient;
        _cacheClient = cacheClient;
    }
    return self;
}

- (RACSignal *)readStations:(DataFetchPolicy)policy {
    switch (policy) {
        case DataFetchPolicyCacheOnly:
            return [self.cacheClient readStations];
        case DataFetchPolicySourceOnly:
            return [self cacheStations:[self.apiClient readStations]];
        case DataFetchPolicyCacheFirst:
        case DataFetchPolicyDefault:
        default:
            @weakify(self);
            return [[self.cacheClient readStations]
                        flattenMap:^RACSignal *(NSArray *stations) {
                            @strongify(self);
                            if ([stations count] == 0 || stations == nil) {
                                return [self cacheStations:[self.apiClient readStations]];
                            } else {
                                if ([[[stations firstObject] lastUpdated] timeIntervalSinceNow] <= -60*5) {
                                    return [self cacheStations:[self.apiClient readStations]];
                                } else {
                                    return [RACSignal return:stations];
                                }
                            }
                        }];
    }
}

#pragma mark Private methods

- (RACSignal *)cacheStations:(RACSignal *)readSignal {
    @weakify(self);
    return [readSignal
                doNext:^(NSArray *stations) {
                    @strongify(self);
                    [[self.cacheClient cacheStations:stations]
                        subscribeCompleted:^{
                            DDLogInfo(@"Stations cached");
                        }];
                }];
}

@end
