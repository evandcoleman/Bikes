//
//  UIColor+Bikes.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - Utility functions

extern UIColor *UIColorFromRGB(NSUInteger r, NSUInteger g, NSUInteger b);
extern UIColor *UIColorFromRGBA(NSUInteger r, NSUInteger g, NSUInteger b, CGFloat a);

#pragma mark -

@interface UIColor (Bikes)

#pragma mark Color constants

+ (UIColor *)bikes_green;
+ (UIColor *)bikes_orange;
+ (UIColor *)bikes_red;
+ (UIColor *)bikes_blue;

+ (UIColor *)bikes_darkerGray;
+ (UIColor *)bikes_darkGray;
+ (UIColor *)bikes_gray;
+ (UIColor *)bikes_lightGray;
+ (UIColor *)bikes_lighterGray;

@end
