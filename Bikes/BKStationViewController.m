//
//  BKStationDetailView.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationViewController.h"

#import "BKStationViewModel.h"

#import <PureLayout/PureLayout.h>

@interface BKStationViewController ()

@property (nonatomic) UIImageView *mapImageView;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *bikesLabel;
@property (nonatomic) UILabel *docksLabel;
@property (nonatomic) UILabel *lastUpdatedLabel;

@end

@implementation BKStationViewController

- (instancetype)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        self.view.backgroundColor = [UIColor bikes_white];
        
        UINavigationBar *navigationBar = [[UINavigationBar alloc] initForAutoLayout];
        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:nil action:nil];
        @weakify(self);
        doneButton.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            @strongify(self);
            [self dismissViewControllerAnimated:YES completion:nil];
            return [RACSignal empty];
        }];
        navigationBar.topItem.rightBarButtonItem = doneButton;
        navigationBar.topItem.title = @"Station";
        [self.view addSubview:navigationBar];
        
        _mapImageView = [[UIImageView alloc] initForAutoLayout];
        _mapImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.view addSubview:_mapImageView];
        
        _nameLabel = [[UILabel alloc] initForAutoLayout];
        _nameLabel.textColor = [UIColor bikes_darkerGray];
        _nameLabel.font = [UIFont bikes_boldWithSize:16];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_nameLabel];
        
        _bikesLabel = [[UILabel alloc] initForAutoLayout];
        _bikesLabel.textColor = [UIColor bikes_darkGray];
        _bikesLabel.font = [UIFont bikes_boldWithSize:24];
        [self.view addSubview:_bikesLabel];
        
        _docksLabel = [[UILabel alloc] initForAutoLayout];
        _docksLabel.textColor = [UIColor bikes_darkGray];
        _docksLabel.font = [UIFont bikes_boldWithSize:24];
        [self.view addSubview:_docksLabel];
        
        _lastUpdatedLabel = [[UILabel alloc] initForAutoLayout];
        _lastUpdatedLabel.textColor = [UIColor bikes_gray];
        _lastUpdatedLabel.font = [UIFont bikes_boldWithSize:12];
        _lastUpdatedLabel.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_lastUpdatedLabel];
        
        RAC(self.nameLabel, text) = RACObserve(self, viewModel.name);
        RAC(self.bikesLabel, text) = RACObserve(self, viewModel.availableBikes);
        RAC(self.docksLabel, text) = RACObserve(self, viewModel.availableDocks);
        RAC(self.lastUpdatedLabel, text) = RACObserve(self, viewModel.lastUpdated);
        
        [navigationBar autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
        [navigationBar autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [navigationBar autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        
        [_mapImageView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:navigationBar withOffset:0];
        [_mapImageView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [_mapImageView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [_mapImageView autoSetDimension:ALDimensionHeight toSize:80];
        
        [_nameLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mapImageView withOffset:15];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    }
    return self;
}

@end
