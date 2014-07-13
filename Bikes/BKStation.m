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
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
       @"1": @(BKStationStatusInService),
       @"3": @(BKStationStatusOutOfService),
    }];
}

@end
