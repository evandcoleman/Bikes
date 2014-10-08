//
//  BKAPICacheClient.m
//  Bikes
//
//  Created by Evan Coleman on 10/7/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKAPICacheClient.h"

#import <YapDatabase/YapDatabase.h>

NSString * const DatabaseCollectionKey = @"BKStationsCollectiom";
NSString * const DatabaseStationsKey = @"BKStation";
NSString * const DatabaseLastUpdateKey = @"BKLastUpdated";

@interface BKAPICacheClient ()

@property (nonatomic, readonly) YapDatabase *database;

@end

@implementation BKAPICacheClient

- (instancetype)init {
    self = [super init];
    if (self != nil) {
        NSString *containerDirectory = [[[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:@"group.net.evancoleman.Bikes"] path];
        _database = [[YapDatabase alloc] initWithPath:[containerDirectory stringByAppendingPathComponent:@"stations"]];
    }
    return self;
}

- (RACSignal *)readStations {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        YapDatabaseConnection *connection = [self.database newConnection];
        [connection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            NSArray *stationViewModels = [transaction objectForKey:DatabaseStationsKey inCollection:DatabaseCollectionKey];
            [subscriber sendNext:stationViewModels];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

- (RACSignal *)cacheStations:(NSArray *)stations {
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        YapDatabaseConnection *connection = [self.database newConnection];
        [connection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
            [transaction setObject:stations forKey:DatabaseStationsKey inCollection:DatabaseCollectionKey];
            [transaction setObject:[NSDate date] forKey:DatabaseLastUpdateKey inCollection:DatabaseCollectionKey];
            [subscriber sendCompleted];
        }];
        
        return nil;
    }];
}

@end
