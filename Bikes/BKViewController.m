//
//  BKViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewController.h"

@interface BKViewController ()

@property (nonatomic) RVMViewModel *viewModel;

@end

@implementation BKViewController

- (instancetype)initWithViewModel:(RVMViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.viewModel.active = YES;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    self.viewModel.active = NO;
}

@end
