//
//  UIColor+Bikes.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "UIColor+Bikes.h"

#pragma mark - Utility functions

UIColor *UIColorFromRGB(NSUInteger r, NSUInteger g, NSUInteger b) {
    return UIColorFromRGBA(r, g, b, 1.0);
}

UIColor *UIColorFromRGBA(NSUInteger r, NSUInteger g, NSUInteger b, CGFloat a) {
    return [UIColor colorWithRed:(r == 0 ? 0 : (r / 255.0))
                           green:(g == 0 ? 0 : (g / 255.0))
                            blue:(b == 0 ? 0 : (b / 255.0))
                           alpha:a];
}

#pragma mark -

@implementation UIColor (Bikes)

#pragma mark Color constants

// Colors shold be prefixed with bikes_
+ (UIColor *)bikes_green { return UIColorFromRGB(105, 255, 102); }
+ (UIColor *)bikes_orange { return UIColorFromRGB(255, 165, 0); }
+ (UIColor *)bikes_red { return UIColorFromRGB(255, 60, 60); }
+ (UIColor *)bikes_blue { return UIColorFromRGB(120, 155, 255); }

+ (UIColor *)bikes_darkerGray { return UIColorFromRGB(76, 76, 76); }
+ (UIColor *)bikes_darkGray { return UIColorFromRGB(102, 102, 102); }
+ (UIColor *)bikes_gray { return UIColorFromRGB(153, 153, 153); }
+ (UIColor *)bikes_lightGray { return UIColorFromRGB(204, 204, 204); }
+ (UIColor *)bikes_lighterGray { return UIColorFromRGB(230, 230, 230); }

@end