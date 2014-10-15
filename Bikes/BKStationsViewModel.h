//
//  BKStationsViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 9/21/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewModel.h"

@class BKStationsController;

@interface BKStationsViewModel : BKViewModel

@property (nonatomic, readonly) NSArray *viewModels;

@property (nonatomic, readonly) RACCommand *loadStationsCommand;

@property (nonatomic, readonly) RACCommand *refreshStationsCommand;

@property (nonatomic, readonly) RACCommand *favoriteStationCommand;

- (instancetype)initWithStationsController:(BKStationsController *)stationsController;

@end
