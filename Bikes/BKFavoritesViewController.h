//
//  BKFavoritesViewController.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class BKFavoritesViewModel;

@interface BKFavoritesViewController : UITableViewController

@property (nonatomic, readonly) BKFavoritesViewModel *viewModel;

- (instancetype)initWithViewModel:(BKFavoritesViewModel *)viewModel;

@end
