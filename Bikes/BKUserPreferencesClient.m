//
//  BKUserPreferencesClient.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKUserPreferencesClient.h"

@interface BKUserPreferencesClient ()

@property (nonatomic, readonly) NSUserDefaults *userDefaults;

@end

@implementation BKUserPreferencesClient

+ (instancetype)sharedUserPreferencesClient {
    static BKUserPreferencesClient *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[BKUserPreferencesClient alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        _userDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.net.evancoleman.Bikes"];
    }
    return self;
}

- (void)setObject:(id<NSCoding>)object forKey:(NSString *)aKey {
    [self.userDefaults setObject:object forKey:aKey];
    [self.userDefaults synchronize];
}

- (RACSignal *)objectForKey:(NSString *)aKey {
    return [RACSignal return:[self.userDefaults objectForKey:aKey]];
}

- (BOOL)stationIsFavorite:(NSInteger)stationID {
    return [[[[[self objectForKey:@"BKFavoriteStations"]
        flattenMap:^RACStream *(NSArray *favorites) {
            return favorites.rac_sequence.signal;
        }] filter:^BOOL(NSNumber *station) {
            return ([station integerValue] == stationID);
        }] first] boolValue];
}

@end
