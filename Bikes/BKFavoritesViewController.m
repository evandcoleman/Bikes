//
//  BKFavoritesViewController.m
//  Bikes
//
//  Created by Evan Coleman on 7/16/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKFavoritesViewController.h"

#import "BKStationViewModel.h"
#import "BKFavoritesViewModel.h"
#import "BKStationTableViewCell.h"
#import "BKAnnotationView.h"

#import <MapKit/MapKit.h>
#import <PureLayout/PureLayout.h>

@interface BKFavoritesViewController () <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>

@property (nonatomic) BKFavoritesViewModel *viewModel;

@property (nonatomic) UITableView *tableView;
@property (nonatomic) MKMapView *mapView;

@end

@implementation BKFavoritesViewController

- (instancetype)initWithViewModel:(BKFavoritesViewModel *)viewModel {
    self = [super initWithViewModel:viewModel];
    if (self != nil) {
        self.navigationItem.title = @"Stations";
        self.tabBarItem.image = [UIImage imageNamed:@"favorites"];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[BKStationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKStationTableViewCell class])];
        [self.view addSubview:_tableView];
        
        _mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
        _mapView.delegate = self;
        [self.view addSubview:_mapView];
        
        [_mapView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:(UIView *)self.topLayoutGuide];
        [_mapView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [_mapView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [_mapView autoSetDimension:ALDimensionHeight toSize:120];
        
        [_tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_mapView withOffset:0];
        [_tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [_tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [_tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:(UIView *)self.bottomLayoutGuide];
        
        [[RACObserve(self, viewModel.stationViewModels)
            mapReplace:_tableView]
            subscribeNext:^(UITableView *tableView) {
                 [tableView reloadData];
            }];
        
        @weakify(self);
        [[[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)]
            reduceEach:^NSNumber *(UITableView *_, NSIndexPath *indexPath){
                return @(indexPath.row);
            }] map:^BKStationViewModel *(NSNumber *idx) {
                @strongify(self);
                return self.viewModel.stationViewModels[[idx integerValue]];
            }] subscribeNext:^(BKStationViewModel *stationViewModel) {
                @strongify(self);
                [self.mapView removeAnnotations:self.mapView.annotations];
                [self.mapView addAnnotation:stationViewModel];
                [self.mapView setRegion:MKCoordinateRegionMake(stationViewModel.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
            }];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel.updateCommand execute:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.viewModel.stationViewModels count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BKStationTableViewCell class])];
    
    BKStationViewModel *stationViewModel = self.viewModel.stationViewModels[indexPath.row];
    cell.viewModel = stationViewModel;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 54.0;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - MKMapViewDelegate

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BKStationViewModel class]]) {
        BKAnnotationView *annotationView = [[BKAnnotationView alloc] initWithStationViewModel:annotation reuseIdentifier:NSStringFromClass([BKAnnotationView class])];
        annotationView.frame = CGRectMake(0, 0, 25, 50);
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end
