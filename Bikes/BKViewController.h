//
//  BKViewController.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

@class BKViewModel;

@interface BKViewController : UIViewController

@property (nonatomic, readonly) BKViewModel *viewModel;

- (instancetype)initWithViewModel:(BKViewModel *)viewModel;

@end
