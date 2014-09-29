//
//  BKStationsViewModel.m
//  Bikes
//
//  Created by Evan Coleman on 9/21/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKStationsViewModel.h"

#import "BKAPIClient.h"
#import "BKLocationManager.h"

#import "BKStationViewModel.h"

#import <YapDatabase/YapDatabase.h>

NSString * const DatabaseCollectionKey = @"stations";
NSString * const DatabaseViewModelsKey = @"viewModels";
NSString * const DatabaseLastUpdateKey = @"lastUpdate";

@interface BKStationsViewModel ()

@property (nonatomic, readonly) RACCommand *loadStationsCommand;

@property (nonatomic, readonly) YapDatabase *database;

@end

@implementation BKStationsViewModel

- (instancetype)initWithAPIClient:(BKAPIClient *)apiClient locationManager:(BKLocationManager *)locationManager {
    self = [super init];
    if (self != nil) {
        NSString *containerDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.net.evancoleman.Bikes"] path];
        _database = [[YapDatabase alloc] initWithPath:[containerDirectory stringByAppendingPathComponent:@"stations"]];
        
        _loadStationsCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id _) {
            return [[[[RACSignal combineLatest:@[ [apiClient readStations], [locationManager.locationSignal take:1] ]]
                        distinctUntilChanged]
                        map:^NSArray *(RACTuple *t) {
                            RACTupleUnpack(NSArray *stations, CLLocation *location) = t;
                            return [[stations.rac_sequence
                                        map:^BKStationViewModel *(BKStation *station) {
                                            CLLocation *stationLocation = [[CLLocation alloc] initWithLatitude:station.latitude longitude:station.longitude];
                                            CGFloat distance = [stationLocation distanceFromLocation:location];
                                            station.distance = distance;
                                            
                                            BKStationViewModel *viewModel = [[BKStationViewModel alloc] initWithStation:station];
                                            return viewModel;
                                        }]
                                        array];
                        }]
                        map:^NSArray *(NSArray *stationViewModels) {
                            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distance" ascending:YES];
                            return [stationViewModels sortedArrayUsingDescriptors:@[sortDescriptor]];
                        }];
        }];
        
        @weakify(self);
        [[[[_loadStationsCommand executionSignals]
            switchToLatest]
            ignore:nil]
            subscribeNext:^(NSArray *stationViewModels) {
                @strongify(self);
                YapDatabaseConnection *connection = [self.database newConnection];
                [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
                    [transaction setObject:stationViewModels forKey:DatabaseViewModelsKey inCollection:DatabaseCollectionKey];
                    [transaction setObject:[NSDate date] forKey:DatabaseLastUpdateKey inCollection:DatabaseCollectionKey];
                }];
            }];
    }
    return self;
}

- (RACSignal *)viewModels:(BOOL)fromSource {
    @weakify(self);
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        @strongify(self);
        YapDatabaseConnection *connection = [self.database newConnection];
        [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            NSDate *lastUpdate = [transaction objectForKey:DatabaseLastUpdateKey inCollection:DatabaseCollectionKey];
            if ([lastUpdate timeIntervalSinceNow] <= -60*5 || fromSource) {
                [subscriber sendNext:[[self.loadStationsCommand execute:nil] first]];
            } else {
                NSArray *stationViewModels = [transaction objectForKey:DatabaseViewModelsKey inCollection:DatabaseCollectionKey];
                [subscriber sendNext:stationViewModels];
            }
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

@end
