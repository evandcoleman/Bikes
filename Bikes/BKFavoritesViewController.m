//
//  BKFavoritesViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKFavoritesViewController.h"

#import "BKFavoritesViewModel.h"
#import "BKStationTableViewCell.h"

@interface BKFavoritesViewController ()

@property (nonatomic) BKFavoritesViewModel *viewModel;

@end

@implementation BKFavoritesViewController

- (instancetype)initWithViewModel:(BKFavoritesViewModel *)viewModel {
    self = [super initWithStyle:UITableViewStylePlain];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.tabBarItem.image = [UIImage imageNamed:@"favorites"];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        
        [self.tableView registerClass:[BKStationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKStationTableViewCell class])];
        
        [[RACObserve(self, viewModel.stationViewModels)
            mapReplace:self.tableView]
            subscribeNext:^(UITableView *tableView) {
                 [tableView reloadData];
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.stationViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BKStationTableViewCell class])];
    
    cell.textLabel.text = @"Test";
    
    return cell;
}

@end
