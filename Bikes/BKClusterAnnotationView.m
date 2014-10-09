//
//  BKClusterAnnotationView.m
//  Bikes
//
//  Created by Evan Coleman on 10/8/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKClusterAnnotationView.h"

#import <FBAnnotationClustering/FBAnnotationClustering.h>
#import <PureLayout/PureLayout.h>

CGFloat const StrokeWidth = 3;

@interface BKClusterAnnotationView ()

@property (nonatomic, readonly) UILabel *countLabel;

@end

@implementation BKClusterAnnotationView

- (instancetype)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shouldRasterize = YES;
        
        _countLabel = [[UILabel alloc] initForAutoLayout];
        _countLabel.textColor = [UIColor whiteColor];
        _countLabel.font = [UIFont bikes_boldWithSize:12];
        _countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_countLabel];
        
        [_countLabel autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:0];
        [_countLabel autoPinEdgeToSuperviewEdge:ALEdgeRight withInset:0];
        [_countLabel autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    
    self.countLabel.text = [NSString stringWithFormat:@"%lu", [(FBAnnotationCluster *)annotation annotations].count];
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(StrokeWidth, StrokeWidth, CGRectGetWidth(self.bounds) - StrokeWidth*2, CGRectGetHeight(self.bounds) - StrokeWidth*2)];
    [[UIColor bikes_blue] set];
    [path fill];
    [[UIColor whiteColor] set];
    [path setLineWidth:StrokeWidth];
    [path stroke];
}

@end
