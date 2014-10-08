//
//  BKAPICacheClient.h
//  Bikes
//
//  Created by Evan Coleman on 10/7/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@interface BKAPICacheClient : NSObject

- (RACSignal *)readStations;
- (RACSignal *)cacheStations:(NSArray *)stations;

@end
