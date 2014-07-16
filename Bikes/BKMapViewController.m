//
//  BKMapViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/14/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKMapViewController.h"
#import "BKAPIClient.h"
#import "BKStationViewModel.h"
#import "BKAnnotationView.h"

#import <MapKit/MapKit.h>
#import <PureLayout/PureLayout.h>

@interface BKMapViewController () <MKMapViewDelegate>

@property (nonatomic) BKAPIClient *apiClient;
@property (nonatomic) MKMapView *mapView;

@end

@implementation BKMapViewController

- (id)init {
    self = [super initWithNibName:nil bundle:nil];
    if (self != nil) {
        @weakify(self);
        
        _apiClient = [[BKAPIClient alloc] init];
        [[_apiClient fetchStations]
            subscribeNext:^(NSArray *stations) {
                [stations.rac_sequence.signal subscribeNext:^(BKStation *station) {
                    @strongify(self);
                    
                    BKStationViewModel *stationViewModel = [[BKStationViewModel alloc] initWithStation:station];
                    [self.mapView addAnnotation:stationViewModel];
                }];
            }];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
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
