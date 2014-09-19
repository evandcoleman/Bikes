//
//  BKStationView.h
//  Bikes
//
//  Created by Evan Coleman on 9/18/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKStation;

@interface BKStationSlimTableViewCell : UITableViewCell

@property (nonatomic) BKStation *station;

@property (nonatomic, readonly) UILabel *bikesValueLabel;
@property (nonatomic, readonly) UILabel *docksValueLabel;
@property (nonatomic, readonly) UILabel *nameLabel;
@property (nonatomic, readonly) UILabel *distanceLabel;

@end
