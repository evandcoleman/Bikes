//
//  BKAPIClient.m
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKAPIClient.h"

#import "BKStation.h"

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
        self.stationsSignal = [[[self rac_GET:@"stations/json" parameters:nil]
          map:^id(BKStationsResponse *response) {
              return response.result;
          }] replayLast];
    }
    return self;
}

- (RACSignal *)stationsNearLocation:(CLLocation *)location {
    return [[self.stationsSignal
                flattenMap:^RACStream *(NSArray *stations) {
                    return stations.rac_sequence.signal;
                }]
                filter:^BOOL(BKStation *station) {
                    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                    return ([stationLocation distanceFromLocation:location] < 1000);
                }];
}

@end
