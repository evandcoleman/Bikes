//
//  BKTabBarController.m
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKTabBarController.h"

#import "BKMapViewController.h"
#import "BKMapViewModel.h"
#import "BKStationViewModel.h"
#import "BKTabBarViewModel.h"

@interface BKTabBarController ()

@property (nonatomic) BKTabBarViewModel *viewModel;

@property (nonatomic) RACCommand *presentViewModelCommand;

@end

@implementation BKTabBarController

- (id)initWithViewModel:(BKTabBarViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _viewModel = viewModel;
        
        BKMapViewModel *mapViewModel = [[BKMapViewModel alloc] initWithAPIClient:viewModel.apiClient openStationCommand:viewModel.openViewModelCommand];
        UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:[[BKMapViewController alloc] initWithViewModel:mapViewModel]];
        
        [self setViewControllers:@[mapNavigationController]
                        animated:NO];
        
        [_viewModel.presentViewModelSignal subscribeNext:^(RVMViewModel *viewModel) {
            DDLogInfo(@"BKTabBarController wants to present %@", NSStringFromClass([viewModel class]));
            
        }];
    }
    return self;
}

@end
