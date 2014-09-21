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

        _cachedStations = [[self stations] replayLast];
    }
    return self;
}

- (RACSignal *)cachedStations {
    // Refetch every 5 minutes
    if ([self.lastUpdateDate timeIntervalSinceNow] <= -60*5) {
        _cachedStations = [[self stations] replayLast];
    }
    return _cachedStations;
}

- (RACSignal *)stationsNearLocation:(CLLocation *)location {
    return [self.cachedStations
                flattenMap:^RACStream *(NSArray *stations) {
                    return [[stations.rac_sequence
                                filter:^BOOL(BKStation *station) {
                                    // Is doing this here The Right Way To Do It™?
                                    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                                    CGFloat distance = [stationLocation distanceFromLocation:location];
                                    station.distance = distance;
                                    return (distance < 1000);
                                }]
                                signal];
                }];
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
