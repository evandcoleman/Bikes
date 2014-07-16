//
//  BKMapViewController.h
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKMapViewModel;

@interface BKMapViewController : UIViewController

- (instancetype)initWithViewModel:(BKMapViewModel *)viewModel;

@end
