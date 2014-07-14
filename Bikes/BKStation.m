//
//  BKStation.m
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStation.h"

@implementation BKStation

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

@end
