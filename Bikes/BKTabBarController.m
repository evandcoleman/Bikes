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
#import "BKFavoritesViewModel.h"
#import "BKFavoritesViewController.h"

@interface BKTabBarController () <UITabBarControllerDelegate>

@property (nonatomic) BKTabBarViewModel *viewModel;

@property (nonatomic) RACCommand *presentViewModelCommand;

@end

@implementation BKTabBarController

- (id)initWithViewModel:(BKTabBarViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.delegate = self;
        
        BKMapViewModel *mapViewModel = [[BKMapViewModel alloc] initWithAPIClient:viewModel.apiClient openStationCommand:viewModel.openViewModelCommand];
        UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:[[BKMapViewController alloc] initWithViewModel:mapViewModel]];
        
        BKFavoritesViewModel *favoritesViewModel = [[BKFavoritesViewModel alloc] initWithAPIClient:viewModel.apiClient];
        UINavigationController *favoritesNavigationController = [[UINavigationController alloc] initWithRootViewController:[[BKFavoritesViewController alloc] initWithViewModel:favoritesViewModel]];
        
        [self setViewControllers:@[favoritesNavigationController, mapNavigationController]
                        animated:NO];
        
        [_viewModel.presentViewModelSignal subscribeNext:^(RVMViewModel *viewModel) {
            DDLogInfo(@"BKTabBarController wants to present %@", NSStringFromClass([viewModel class]));
            
        }];
        
        [[self rac_signalForSelector:@selector(tabBarController:didSelectViewController:) fromProtocol:@protocol(UITabBarControllerDelegate)]
         subscribeNext:^(UIViewController *viewController) {
            
        }];
    }
    return self;
}

@end
