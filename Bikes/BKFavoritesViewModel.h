//
//  BKFavoritesViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewModel.h"

@class BKStationsViewModel;

@interface BKFavoritesViewModel : BKViewModel

@property (nonatomic, readonly) NSArray *nearbyStationViewModels;
@property (nonatomic, readonly) NSArray *favoriteStationViewModels;

@property (nonatomic, readonly) RACCommand *refreshCommand;

- (instancetype)initWithStationsViewModel:(BKStationsViewModel *)stationsViewModel;

@end
