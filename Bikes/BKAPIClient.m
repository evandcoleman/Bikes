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
        
    }
    return self;
}

- (RACSignal *)readStations {
    DDLogInfo(@"Fetching stations...");
    return [[[self rac_GET:@"stations/json" parameters:nil]
                map:^id(BKStationsResponse *response) {
                    return response.result;
                }]
                map:^NSArray *(NSArray *stations) {
                    return [[stations.rac_sequence
                                map:^BKStation *(BKStation *station) {
                                    station.favorite = [[BKUserPreferencesClient sharedUserPreferencesClient] stationIsFavorite:station.stationID];
                                    return station;
                                }]
                                array];
                }];
}

@end
