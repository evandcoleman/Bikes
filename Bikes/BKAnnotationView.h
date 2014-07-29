//
//  BKAnnotationView.h
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <MapKit/MapKit.h>

@class BKStationViewModel;

@interface BKAnnotationView : MKAnnotationView

@property (nonatomic, readonly) BKStationViewModel *viewModel;

@end
