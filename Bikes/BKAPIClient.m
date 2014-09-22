//
//  BKAPIClient.m
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKAPIClient.h"

#import "BKStation.h"
#import "BKUserPreferencesClient.h"

#import <Overcoat/ReactiveCocoa+Overcoat.h>
#import <CoreLocation/CoreLocation.h>

@interface BKAPIClient ()

@property (nonatomic) RACSignal *cachedStations;

@property (nonatomic) NSDate *lastUpdateDate;

@end

@implementation BKAPIClient

+ (NSDictionary *)modelClassesByResourcePath {
    return @{
             @"stations/*": [BKStation class],
             };
}

+ (Class)responseClass {
    return [BKStationsResponse class];
}

- (instancetype)init {
    self = [super initWithBaseURL:[NSURL URLWithString:@"http://citibikenyc.com"]];
    if (self != nil) {
        _lastUpdateDate = [NSDate distantPast];
    }
    return self;
}

- (RACSignal *)readStations {
    // Refetch every 5 minutes
    if ([self.lastUpdateDate timeIntervalSinceNow] <= -60*5) {
        self.cachedStations = [[self stations] replayLast];
    }
    return self.cachedStations;
}

- (void)clearCache {
    self.cachedStations = nil;
    self.lastUpdateDate = [NSDate distantPast];
}

#pragma mark - Private

- (RACSignal *)stations {
    DDLogInfo(@"Fetching stations...");
    self.lastUpdateDate = [NSDate date];
    return [[[self rac_GET:@"stations/json" parameters:nil]
                map:^id(BKStationsResponse *response) {
                    return response.result;
                }]
                flattenMap:^RACStream *(NSArray *stations) {
                    return [[[stations.rac_sequence
                                map:^BKStation *(BKStation *station) {
                                    station.favorite = [[BKUserPreferencesClient sharedUserPreferencesClient] stationIsFavorite:station.stationID];
                                    return station;
                                }]
                                signal]
                                collect];
                }];
}

@end
