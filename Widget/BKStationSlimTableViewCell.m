//
//  BKStationView.m
//  Bikes
//
//  Created by Evan Coleman on 9/18/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationSlimTableViewCell.h"

#import <PureLayout/PureLayout.h>

@interface BKStationSlimTableViewCell ()

@end

@implementation BKStationSlimTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        
        _bikesValueLabel = [[UILabel alloc] initForAutoLayout];
        _bikesValueLabel.textAlignment = NSTextAlignmentCenter;
        _bikesValueLabel.font = [UIFont systemFontOfSize:16];
        _bikesValueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_bikesValueLabel];
        
        _docksValueLabel = [[UILabel alloc] initForAutoLayout];
        _docksValueLabel.textAlignment = NSTextAlignmentCenter;
        _docksValueLabel.font = [UIFont systemFontOfSize:16];
        _docksValueLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_docksValueLabel];
        
        _nameLabel = [[UILabel alloc] initForAutoLayout];
        _nameLabel.font = [UIFont systemFontOfSize:16];
        _nameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_nameLabel];
        
        _distanceLabel = [[UILabel alloc] initForAutoLayout];
        _distanceLabel.font = [UIFont systemFontOfSize:9];
        _distanceLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_distanceLabel];
        
        UILabel *bikesLabel = [[UILabel alloc] initForAutoLayout];
        bikesLabel.text = @"Bikes";
        bikesLabel.textAlignment = NSTextAlignmentCenter;
        bikesLabel.font = [UIFont systemFontOfSize:9];
        bikesLabel.textColor = [UIColor lightTextColor];
        [self.contentView addSubview:bikesLabel];
        
        UILabel *docksLabel = [[UILabel alloc] initForAutoLayout];
        docksLabel.text = @"Docks";
        docksLabel.textAlignment = NSTextAlignmentCenter;
        docksLabel.font = [UIFont systemFontOfSize:9];
        docksLabel.textColor = [UIColor lightTextColor];
        [self.contentView addSubview:docksLabel];
        
        [_docksValueLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:14];
        [_docksValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:self.contentView withOffset:-5];
        [_docksValueLabel autoSetDimension:ALDimensionWidth toSize:30];
        
        [_bikesValueLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_docksValueLabel withOffset:-10];
        [_bikesValueLabel autoAlignAxis:ALAxisHorizontal toSameAxisOfView:_docksValueLabel];
        [_bikesValueLabel autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:_docksValueLabel];
        
        [_nameLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:18];
        [_nameLabel autoPinEdge:ALEdgeRight toEdge:ALEdgeLeft ofView:_bikesValueLabel withOffset:-10];
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

@end
