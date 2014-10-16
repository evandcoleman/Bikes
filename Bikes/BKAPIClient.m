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
#import "BKLocationManager.h"

#import <Overcoat/ReactiveCocoa+Overcoat.h>
#import <CoreLocation/CoreLocation.h>

@interface BKAPIClient ()

@property (nonatomic) BKLocationManager *locationManager;

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
        _locationManager = [[BKLocationManager alloc] init];
    }
    return self;
}

- (RACSignal *)readStations {
    DDLogInfo(@"Fetching stations...");
    return [[[[[self rac_GET:@"stations/json" parameters:nil]
                map:^id(BKStationsResponse *response) {
                    return response.result;
                }]
                map:^NSArray *(NSArray *stations) {
                    return [[stations.rac_sequence
                                map:^BKStation *(BKStation *station) {
                                    station.favorite = [[BKUserPreferencesClient sharedUserPreferencesClient] stationIsFavorite:station.stationID];
                                    station.lastUpdated = [NSDate date];
                                    return station;
                                }]
                                array];
                }]
                flattenMap:^RACStream *(NSArray *stations) {
                    return [[[[[self.locationManager locationSignal]
                                take:1]
                                timeout:10 onScheduler:[RACScheduler scheduler]]
                                map:^RACTuple *(CLLocation *location) {
                                    return RACTuplePack(stations, location);
                                }]
                                catchTo:[RACSignal return:RACTuplePack(stations, nil)]];
                }]
                map:^NSArray *(RACTuple *t) {
                    RACTupleUnpack(NSArray *stations, CLLocation *location) = t;
                    if (location == nil) {
                        return stations;
                    }
                    return [[stations.rac_sequence
                                map:^BKStation *(BKStation *station) {
                                    CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                                    CGFloat distance = [stationLocation distanceFromLocation:location];
                                    station.distance = distance;
                                    return station;
                                }]
                                array];
                }];
}

@end
