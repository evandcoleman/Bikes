//
//  UIFont+Bikes.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "UIFont+Bikes.h"

@implementation UIFont (Bikes)

+ (UIFont *)bikes_regularWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Medium" size:size];
}

+ (UIFont *)bikes_boldWithSize:(CGFloat)size {
    return [UIFont fontWithName:@"Avenir-Black" size:size];
}

@end
