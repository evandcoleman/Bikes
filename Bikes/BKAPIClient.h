//
//  BKAPIClient.h
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Overcoat/OVCHTTPSessionManager.h>
#import "BKStationsResponse.h"

@interface BKAPIClient : OVCHTTPSessionManager

// Sends NSArray of BKStation
- (RACSignal *)fetchStations;

@end
