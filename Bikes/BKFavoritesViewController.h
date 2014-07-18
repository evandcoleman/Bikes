//
//  BKFavoritesViewController.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewController.h"

@class BKFavoritesViewModel;

@interface BKFavoritesViewController : BKViewController

- (instancetype)initWithViewModel:(BKFavoritesViewModel *)viewModel;

@end
