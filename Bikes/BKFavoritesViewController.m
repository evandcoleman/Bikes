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
#import "BKStation.h"

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
        self.tabBarItem.image = [UIImage imageNamed:@"favorites"];
        [self.tabBarItem setImageInsets:UIEdgeInsetsMake(5, 0, -5, 0)];
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBarHidden = YES;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[BKStationTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKStationTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    // TODO: Execute both commands
    refreshControl.rac_command = self.viewModel.refreshCommand;
    [self.tableView addSubview:refreshControl];
    
    self.mapView = [[MKMapView alloc] initWithFrame:CGRectZero];
    self.mapView.delegate = self;
    self.mapView.region = MKCoordinateRegionMake(CLLocationCoordinate2DMake(40.712784, -74.005941), MKCoordinateSpanMake(0.03, 0.03));
    [self.view addSubview:self.mapView];
    
    [self.mapView autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:0];
    [self.mapView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.mapView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.mapView autoSetDimension:ALDimensionHeight toSize:130];
    
    [self.tableView autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:self.mapView withOffset:0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
    [self.tableView autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
    [self.tableView autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:(UIView *)self.bottomLayoutGuide];
    
    [[RACObserve(self, viewModel.favoriteStationViewModels)
      mapReplace:self.tableView]
     subscribeNext:^(UITableView *tableView) {
         [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
     }];
    
    [[RACObserve(self, viewModel.nearbyStationViewModels)
      mapReplace:self.tableView]
     subscribeNext:^(UITableView *tableView) {
         [tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
     }];
    
    @weakify(self);
    
    [[[[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate)]
       reduceEach:^NSIndexPath *(UITableView *_, NSIndexPath *indexPath){
           return indexPath;
       }] map:^BKStationViewModel *(NSIndexPath *indexPath) {
           @strongify(self);
           if (indexPath.section == 0) {
               return self.viewModel.favoriteStationViewModels[indexPath.row];
           } else {
               return self.viewModel.nearbyStationViewModels[indexPath.row];
           }
       }] subscribeNext:^(BKStationViewModel *stationViewModel) {
           @strongify(self);
           [self.mapView removeAnnotations:self.mapView.annotations];
           [self.mapView addAnnotation:stationViewModel];
           [self.mapView setRegion:MKCoordinateRegionMake(stationViewModel.coordinate, MKCoordinateSpanMake(0.003, 0.003)) animated:YES];
       }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.viewModel.refreshCommand execute:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return [self.viewModel.favoriteStationViewModels count];
    } else {
        return [self.viewModel.nearbyStationViewModels count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKStationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BKStationTableViewCell class])];
    
    BKStationViewModel *stationViewModel = nil;
    UIImageView *favoriteImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star"]];
    if (indexPath.section == 0) {
        stationViewModel = self.viewModel.favoriteStationViewModels[indexPath.row];
        // TODO: Do this in the cell
        [cell setSwipeGestureWithView:favoriteImageView
                                color:[UIColor bikes_red]
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          [[stationViewModel.favoriteStationCommand execute:@NO] subscribeCompleted:^{
                              [self.viewModel.refreshCommand execute:nil];
                          }];
                      }];
    } else {
        stationViewModel = self.viewModel.nearbyStationViewModels[indexPath.row];
        [cell setSwipeGestureWithView:favoriteImageView
                                color:[UIColor bikes_green]
                                 mode:MCSwipeTableViewCellModeExit
                                state:MCSwipeTableViewCellState3
                      completionBlock:^(MCSwipeTableViewCell *cell, MCSwipeTableViewCellState state, MCSwipeTableViewCellMode mode) {
                          [[stationViewModel.favoriteStationCommand execute:@YES] subscribeCompleted:^{
                              [self.viewModel.refreshCommand execute:nil];
                          }];
                      }];
    }
    cell.viewModel = stationViewModel;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return @"Favorites";
    } else {
        return @"Nearby";
    }
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
        BKAnnotationView *annotationView = [[BKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([BKAnnotationView class])];
        annotationView.frame = CGRectMake(0, 0, 25, 50);
        annotationView.annotation = annotation;
        
        return annotationView;
    }
    
    return nil;
}

@end
