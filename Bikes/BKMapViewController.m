//
//  BKMapViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKMapViewController.h"
#import "BKStationViewModel.h"
#import "BKAnnotationView.h"
#import "BKMapViewModel.h"

#import <MapKit/MapKit.h>
#import <PureLayout/PureLayout.h>

@interface BKMapViewController () <MKMapViewDelegate>

@property (nonatomic) MKMapView *mapView;

@property (nonatomic) BKMapViewModel *viewModel;

@end

@implementation BKMapViewController

- (id)initWithViewModel:(BKMapViewModel *)viewModel {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        self.tabBarItem.image = [UIImage imageNamed:@"map"];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        
        _viewModel = viewModel;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
	
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];

    
    @weakify(self);
    [[RACObserve(self.viewModel, stationViewModels) ignore:nil] subscribeNext:^(BKStationViewModel *viewModel) {
        @strongify(self);
        [self.mapView addAnnotation:viewModel];
    }];
}

- (void)viewWillLayoutSubviews {
    [self.mapView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {    
    if ([annotation isKindOfClass:[BKStationViewModel class]]) {
        BKAnnotationView *annotationView = [[BKAnnotationView alloc] initWithStationViewModel:annotation reuseIdentifier:NSStringFromClass([BKAnnotationView class])];
        annotationView.frame = CGRectMake(0, 0, 25, 50);
        
        annotationView.canShowCallout = YES;
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end
