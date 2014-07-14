//
//  BKAPIClientSpec.m
//  BKAPIClientSpec
//
//  Created by Evan Coleman on 7/13/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import <Specta/Specta.h>
#define EXP_SHORTHAND
#import <Expecta/Expecta.h>
#define MOCKITO_SHORTHAND
#import <OCMockito/OCMockito.h>

#import "BKAPIClient.h"

SpecBegin(BKAPIClientSpec)

describe(@"BKAPIClient", ^{
    __block BKAPIClient *apiClient;
    
    beforeEach(^{
        apiClient = [[BKAPIClient alloc] init];
    });
    
    describe(@"-fetchStations", ^{
        it(@"should return an instance of BKStationsResponse", ^AsyncBlock {
            [[apiClient fetchStations] subscribeNext:^(BKStationsResponse *response) {
                expect(response).to.beInstanceOf([BKStationsResponse class]);
                done();
            }];
        });
        
        it(@"should return array as result", ^AsyncBlock {
            [[apiClient fetchStations] subscribeNext:^(BKStationsResponse *response) {
                expect(response.result).to.beKindOf([NSArray class]);
                done();
            }];
        });
        
        it(@"should return multiple objects", ^AsyncBlock {
            [[apiClient fetchStations] subscribeNext:^(BKStationsResponse *response) {
                expect(response.result).toNot.beEmpty();
                done();
            }];
        });
        
        it(@"should return BKStation objects", ^AsyncBlock {
            [[apiClient fetchStations] subscribeNext:^(BKStationsResponse *response) {
                BKStation *station = [(NSArray *)response.result firstObject];
                expect(station).to.beInstanceOf([BKStation class]);
                done();
            }];
        });
    });
});

SpecEnd