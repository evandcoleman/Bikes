//
//  BKStationTableViewCell.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationTableViewCell.h"

#import "BKStationViewModel.h"

#import <PureLayout/PureLayout.h>

@interface BKStationTableViewCell ()

@property (nonatomic) UILabel *bikesValueLabel;
@property (nonatomic) UILabel *docksValueLabel;
@property (nonatomic) UILabel *nameLabel;
@property (nonatomic) UILabel *distanceLabel;

@property (nonatomic) RACSignal *favoriteSignal;

@end

@implementation BKStationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        UIView *backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        backgroundView.backgroundColor = [UIColor bikes_lighterGray];
        self.selectedBackgroundView = backgroundView;
        
        _bikesValueLabel = [[UILabel alloc] initForAutoLayout];
        _bikesValueLabel.textAlignment = NSTextAlignmentCenter;
        _bikesValueLabel.font = [UIFont bikes_regularWithSize:16];
        [self.contentView addSubview:_bikesValueLabel];
        
        _docksValueLabel = [[UILabel alloc] initForAutoLayout];
        _docksValueLabel.textAlignment = NSTextAlignmentCenter;
        _docksValueLabel.font = [UIFont bikes_regularWithSize:16];
        [self.contentView addSubview:_docksValueLabel];
        
        _nameLabel = [[UILabel alloc] initForAutoLayout];
        _nameLabel.font = [UIFont bikes_regularWithSize:16];
        [self.contentView addSubview:_nameLabel];
        
        _distanceLabel = [[UILabel alloc] initForAutoLayout];
        _distanceLabel.font = [UIFont bikes_regularWithSize:9];
        _distanceLabel.textColor = [UIColor bikes_gray];
        [self.contentView addSubview:_distanceLabel];
        
        UILabel *bikesLabel = [[UILabel alloc] initForAutoLayout];
        bikesLabel.text = @"Bikes";
        bikesLabel.textAlignment = NSTextAlignmentCenter;
        bikesLabel.font = [UIFont bikes_regularWithSize:9];
        bikesLabel.textColor = [UIColor bikes_gray];
        [self.contentView addSubview:bikesLabel];
        
        UILabel *docksLabel = [[UILabel alloc] initForAutoLayout];
        docksLabel.text = @"Docks";
        docksLabel.textAlignment = NSTextAlignmentCenter;
        docksLabel.font = [UIFont bikes_regularWithSize:9];
        docksLabel.textColor = [UIColor bikes_gray];
        [self.contentView addSubview:docksLabel];
        
        [_docksValueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:14];
        [_docksValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:-5];
        [_docksValueLabel autoSetDimension:ALDimensionWidth toSize:30];
        
        [_bikesValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_docksValueLabel withOffset:-10];
        [_bikesValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_docksValueLabel];
        [_bikesValueLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_docksValueLabel];
        
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
        [_nameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_bikesValueLabel withOffset:10];
        [_nameLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
        
        [_distanceLabel autoPinEdge:ALEdgeLeft toEdge:ALEdgeLeft ofView:_nameLabel withOffset:2];
        [_distanceLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_nameLabel];
        [_distanceLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_nameLabel];
        
        [bikesLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_bikesValueLabel];
        [bikesLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_bikesValueLabel withOffset:0];
        [bikesLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_bikesValueLabel];
        
        [docksLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_docksValueLabel];
        [docksLabel autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_docksValueLabel withOffset:0];
        [docksLabel autoAlignAxis:ALAxisVertical toSameAxisOfView:_docksValueLabel];
    }
    return self;
}

- (void)setViewModel:(BKStationViewModel *)viewModel {
    _viewModel = viewModel;
    
    self.bikesValueLabel.text = viewModel.availableBikes;
    self.docksValueLabel.text = viewModel.availableDocks;
    self.nameLabel.text = viewModel.name;
    self.nameLabel.textColor = viewModel.statusColor;
    self.distanceLabel.text = viewModel.distance;
}

@end
