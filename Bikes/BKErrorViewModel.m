//
//  BKErrorViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 10/8/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKErrorViewModel.h"

@implementation BKErrorViewModel

- (instancetype)initWithError:(NSError *)error retryCommand:(RACCommand *)retryCommand {
    self = [super init];
    if (self != nil) {
        _retryCommand = retryCommand;
        
        if ([error.domain isEqualToString:RACSignalErrorDomain] && error.code == 1) {
            _message = @"Error determining location. Did you grant Bikes access to your location?";
        } else {
            _message = [error localizedDescription];
        }
    }
    return self;
}

@end
