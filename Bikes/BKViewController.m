//
//  BKViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewController.h"

#import "BKViewModel.h"
#import "BKErrorViewModel.h"

@interface BKViewController ()

@property (nonatomic) BKViewModel *viewModel;

@end

@implementation BKViewController

- (instancetype)initWithViewModel:(BKViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _viewModel = viewModel;
        
        [[self.viewModel.errorViewModels
            deliverOn:RACScheduler.mainThreadScheduler]
            subscribeNext:^(BKErrorViewModel *viewModel) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"An Error Occurred"
                                                                                         message:viewModel.message
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *retryAction = [UIAlertAction actionWithTitle:@"Retry"
                                                                      style:UIAlertActionStyleDefault
                                                                    handler:^(UIAlertAction *action) {
                                                                        [viewModel.retryCommand execute:nil];
                                                                    }];
                [alertController addAction:retryAction];
                UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Dismiss"
                                                                       style:UIAlertActionStyleDefault
                                                                     handler:nil];
                [alertController addAction:cancelAction];
                
                [self presentViewController:alertController animated:YES completion:nil];
            }];
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
