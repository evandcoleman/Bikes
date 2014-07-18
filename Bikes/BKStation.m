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

- (void)setFavorite:(BOOL)favorite {
    @weakify(self);
    [[[BKUserPreferencesClient objectForKey:@"BKFavoriteStations"]
     map:^id(NSArray *favorites) {
         return [NSMutableSet setWithArray:favorites];
     }] subscribeNext:^(NSMutableSet *favorites) {
         @strongify(self);
         if (favorite) {
             [favorites addObject:@(self.stationID)];
         } else {
             [favorites removeObject:@(self.stationID)];
         }
         [BKUserPreferencesClient setObject:[favorites allObjects] forKey:@"BKFavoriteStations"];
     }];
}

- (BOOL)isFavorite {
    return [[[[[BKUserPreferencesClient objectForKey:@"BKFavoriteStations"]
                flattenMap:^RACStream *(NSArray *favorites) {
                    return favorites.rac_sequence.signal;
                }] filter:^BOOL(NSNumber *stationID) {
                    return ([stationID integerValue] == self.stationID);
                }] take:1] first];
}

@end
