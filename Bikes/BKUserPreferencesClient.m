//
//  BKUserPreferencesClient.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKUserPreferencesClient.h"

@implementation BKUserPreferencesClient

+ (void)setObject:(id<NSCoding>)object forKey:(NSString *)aKey {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:aKey];
    [defaults synchronize];
}

+ (RACSignal *)objectForKey:(NSString *)aKey {
    return [RACSignal return:[[NSUserDefaults standardUserDefaults] objectForKey:aKey]];
}

+ (BOOL)stationIsFavorite:(NSInteger)stationID {
    return [[[[self objectForKey:@"BKFavoriteStations"]
        flattenMap:^RACStream *(NSArray *favorites) {
            return favorites.rac_sequence.signal;
        }] filter:^BOOL(NSNumber *station) {
            return ([station integerValue] == stationID);
        }] first];
}

@end
