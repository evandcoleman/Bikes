//
//  BKViewController.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <ReactiveViewModel/RVMViewModel.h>

@interface BKViewController : UIViewController

@property (nonatomic, readonly) RVMViewModel *viewModel;

- (instancetype)initWithViewModel:(RVMViewModel *)viewModel;

@end
