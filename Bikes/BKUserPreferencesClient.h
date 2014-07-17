//
//  BKUserPreferencesClient.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BKUserPreferencesClient : NSObject

- (RACSignal *)setObject:(id<NSCoding>)object forKey:(NSString *)aKey;
- (RACSignal *)objectForKey:(NSString *)aKey;

@end
