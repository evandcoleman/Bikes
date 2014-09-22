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
#import "BKStationsViewModel.h"
#import "BKTabBarViewModel.h"
#import "BKFavoritesViewModel.h"
#import "BKFavoritesViewController.h"

@interface BKTabBarController () <UITabBarControllerDelegate>

@property (nonatomic) BKTabBarViewModel *viewModel;

@end

@implementation BKTabBarController

- (id)initWithViewModel:(BKTabBarViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.delegate = self;
        
        BKMapViewModel *mapViewModel = [[BKMapViewModel alloc] initWithStationsViewModel:_viewModel.stationsViewModel];
        UINavigationController *mapNavigationController = [[UINavigationController alloc] initWithRootViewController:[[BKMapViewController alloc] initWithViewModel:mapViewModel]];
        
        BKFavoritesViewModel *favoritesViewModel = [[BKFavoritesViewModel alloc] initWithStationsViewModel:_viewModel.stationsViewModel];
        UINavigationController *favoritesNavigationController = [[UINavigationController alloc] initWithRootViewController:[[BKFavoritesViewController alloc] initWithViewModel:favoritesViewModel]];
        
        [self setViewControllers:@[favoritesNavigationController, mapNavigationController]
                        animated:NO];
        
//        [[self rac_signalForSelector:@selector(tabBarController:didSelectViewController:) fromProtocol:@protocol(UITabBarControllerDelegate)]
//         subscribeNext:^(UIViewController *viewController) {
//            
//        }];
    }
    return self;
}

@end
