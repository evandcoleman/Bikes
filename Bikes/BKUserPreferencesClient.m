//
//  BKUserPreferencesClient.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKUserPreferencesClient.h"

@implementation BKUserPreferencesClient

- (RACSignal *)setObject:(id<NSCoding>)object forKey:(NSString *)aKey {
    return [RACSignal defer:^RACSignal *{
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:object forKey:aKey];
        if ([defaults synchronize]) {
            return [RACSignal empty];
        } else {
            return [RACSignal error:nil];
        }
    }];
}

- (RACSignal *)objectForKey:(NSString *)aKey {
    return [RACSignal return:[[NSUserDefaults standardUserDefaults] objectForKey:aKey]];
}

@end
