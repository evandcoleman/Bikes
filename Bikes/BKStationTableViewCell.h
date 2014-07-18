//
//  BKStationTableViewCell.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <MCSwipeTableViewCell/MCSwipeTableViewCell.h>

@class BKStationViewModel;

@interface BKStationTableViewCell : MCSwipeTableViewCell

@property (nonatomic) BKStationViewModel *viewModel;
@property (nonatomic, readonly) RACSignal *favoriteSignal;

@end
