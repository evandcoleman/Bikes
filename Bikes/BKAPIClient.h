//
//  BKAPIClient.h
//  Bikes
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Overcoat/OVCHTTPSessionManager.h>

@interface BKAPIClient : OVCHTTPSessionManager

- (RACSignal *)fetchStations;

@end
