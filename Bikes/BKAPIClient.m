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
        
    }
    return self;
}

- (RACSignal *)fetchStations {
    RACReplaySubject *subject = [RACReplaySubject subject];
    
    [[[self rac_GET:@"stations/json" parameters:nil]
     map:^id(BKStationsResponse *response) {
         return response.result;
     }] subscribeNext:^(NSArray *stations) {
         [stations.rac_sequence.signal subscribeNext:^(BKStation *station) {
             station.lastUpdated = [NSDate date];
             [subject sendNext:station];
         } completed:^{
             [subject sendCompleted];
         }];
     }];
    
    return subject;
}

- (RACSignal *)stationsNearLocation:(CLLocation *)location {
    return [[self fetchStations]
                filter:^BOOL(BKStation *station) {
                    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                    return ([stationLocation distanceFromLocation:location] < 500);
                }];
}

@end
