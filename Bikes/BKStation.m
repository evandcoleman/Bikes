//
//  BKStation.m
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStation.h"

#import "BKUserPreferencesClient.h"

@implementation BKStation

@synthesize favorite = _favorite;

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    return @{
             @"stationID": @"id",
             @"name": @"stationName",
             @"availableDocks": @"availableDocks",
             @"availableBikes": @"availableBikes",
             @"totalDocks": @"totalDocks",
             @"latitude": @"latitude",
             @"longitude": @"longitude",
             @"status": @"statusKey",
             @"statusValue": @"statusValue",
             };
}

+ (NSValueTransformer *)statusJSONTransformer {
    return [MTLValueTransformer transformerWithBlock:^id(id obj) {
        NSUInteger status = [obj integerValue];
        if (status == 1) {
            return @(BKStationStatusInService);
        } else if (status == 3) {
            return @(BKStationStatusOutOfService);
        }
        return @(BKStationStatusUnknown);
    }];
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
//        RAC(self, favorite) = [[[[BKUserPreferencesClient objectForKey:@"BKFavoriteStations"]
//                                   flattenMap:^RACStream *(NSArray *favorites) {
//                                       return favorites.rac_sequence.signal;
//                                   }] filter:^BOOL(NSNumber *stationID) {
//                                       return ([stationID integerValue] == self.stationID);
//                                   }] take:1];
    }
    return self;
}

@end
