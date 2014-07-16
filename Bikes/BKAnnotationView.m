//
//  BKAnnotationView.m
//  Bikes
//
//  Created by Evan Coleman on 7/15/14.
//  Copyright (c) 2014 Evan Coleman. All rights reserved.
//

#import "BKAnnotationView.h"
#import "BKStationViewModel.h"

@interface BKAnnotationView ()

@property (nonatomic) BKStationViewModel *viewModel;

@end

@implementation BKAnnotationView

- (id)initWithStationViewModel:(BKStationViewModel *)viewModel reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:viewModel reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        _viewModel = viewModel;
        
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shouldRasterize = YES;
        
        [[[RACObserve(self, viewModel.statusColor)
            ignore:nil]
            distinctUntilChanged]
            subscribeNext:^(id _) {
                [self setNeedsDisplay];
            }];
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(CGRectGetWidth(rect)/2, 10) radius:8 startAngle:5*M_PI/6 endAngle:M_PI/6 clockwise:YES];
    [path addLineToPoint:CGPointMake(CGRectGetWidth(rect)/2, CGRectGetMidY(rect))];
    [path closePath];
    [self.viewModel.statusColor set];
    [path fill];
    [[UIColor whiteColor] set];
    [path setLineWidth:3.0];
    [path stroke];
}

@end
