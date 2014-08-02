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

@property (nonatomic) RACSignal *stationsSignal;

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

        // TODO: Add APICacheClient that gets a new replay subject each time and saves it.
        // The cache client will decide whether to send that along or get a new one.
        _stationsSignal = [[[[[[self rac_GET:@"stations/json" parameters:nil]
          map:^id(BKStationsResponse *response) {
              return response.result;
          }] flattenMap:^RACStream *(NSArray *stations) {
              return stations.rac_sequence.signal;
          }] map:^BKStation *(BKStation *station) {
              station.favorite = [BKUserPreferencesClient stationIsFavorite:station.stationID];
              return station;
          }] collect] replayLast];
    }
    return self;
}

- (RACSignal *)stationsNearLocation:(CLLocation *)location {
    return [[self.stationsSignal
                flattenMap:^RACStream *(NSArray *stations) {
                    return stations.rac_sequence.signal;
                }]
                filter:^BOOL(BKStation *station) {
                    // Is doing this here The Right Way To Do It™?
                    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                    CGFloat distance = [stationLocation distanceFromLocation:location];
                    station.distance = distance;
                    return (distance < 1000);
                }];
}

@end
