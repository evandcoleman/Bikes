//
//  BKErrorViewModel.h
//  Bikes
//
//  Created by Evan Coleman on 10/8/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKViewModel.h"

@interface BKErrorViewModel : BKViewModel

@property (nonatomic, readonly) NSString *message;

@property (nonatomic, readonly) RACCommand *retryCommand;

- (instancetype)initWithError:(NSError *)error retryCommand:(RACCommand *)retryCommand;

@end
