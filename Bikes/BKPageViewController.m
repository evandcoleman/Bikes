//
//  BKPageViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKPageViewController.h"

#import "BKMapViewController.h"

@interface BKPageViewController ()

@end

@implementation BKPageViewController

- (id)init {
    self = [super initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                    navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                                  options:nil];
    if (self != nil) {
        BKMapViewController *mapViewController = [[BKMapViewController alloc] init];
        
        [self setViewControllers:@[mapViewController]
                       direction:UIPageViewControllerNavigationDirectionForward
                        animated:NO
                      completion:nil];
    }
    return self;
}

@end
