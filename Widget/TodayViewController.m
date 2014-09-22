//
//  TodayViewController.m
//  Widget
//
//  Created by Evan Coleman on 9/18/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "TodayViewController.h"

#import "BKStationSlimTableViewCell.h"

#import "BKAPIClient.h"
#import "BKLocationManager.h"
#import "BKUserPreferencesClient.h"

#import <PureLayout/PureLayout.h>
#import <CoreLocation/CoreLocation.h>
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) BKAPIClient *client;
@property (nonatomic) BKLocationManager *locationManager;
@property (nonatomic) NSArray *stations;

@property (nonatomic) UITableView *tableView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.client = [[BKAPIClient alloc] init];
//    self.locationManager = [[BKLocationManager alloc] init];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[BKStationSlimTableViewCell class] forCellReuseIdentifier:NSStringFromClass([BKStationSlimTableViewCell class])];
    [self.view addSubview:self.tableView];
    
    @weakify(self);
    [[RACObserve(self, stations)
        map:^NSNumber *(NSArray *stations) {
            @strongify(self);
            return @([stations count] * [self tableView:nil heightForRowAtIndexPath:nil]);
        }]
        subscribeNext:^(NSNumber *height) {
            @strongify(self);
            [self setPreferredContentSize:CGSizeMake(CGRectGetWidth(self.view.bounds), [height doubleValue])];
        }];
    
    [self.tableView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero excludingEdge:ALEdgeBottom];
    [self.tableView autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:self.view];
    [self.tableView autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:self.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    @weakify(self);
    [[[[self.client readStations]
        flattenMap:^RACSignal *(NSArray *stations) {
            return [[[stations.rac_sequence
                        filter:^BOOL(BKStation *station) {
                            return station.favorite;
                        }]
                        signal]
                        collect];
        }]
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSArray *stations) {
            @strongify(self);
            self.stations = stations;
            [self.tableView reloadData];
            completionHandler(NCUpdateResultNewData);
        }
        error:^(NSError *error) {
            completionHandler(NCUpdateResultFailed);
        }];
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.stations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BKStationSlimTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BKStationSlimTableViewCell class]) forIndexPath:indexPath];
    
    BKStation *station = self.stations[indexPath.row];
    cell.bikesValueLabel.text = [@(station.availableBikes) stringValue];
    cell.docksValueLabel.text = [@(station.availableDocks) stringValue];
    cell.nameLabel.text = station.name;
    
    return cell;
}

@end
