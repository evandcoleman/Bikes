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


@end

@implementation BKAnnotationView

- (id)initWithAnnotation:(id<MKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self != nil) {
        self.backgroundColor = [UIColor clearColor];
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shouldRasterize = YES;
        
        // TODO: Keep this button state in sync with the favorite property on the view model.
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:@"star_off"] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:@"star_on"] forState:UIControlStateSelected];
        [button sizeToFit];
        
        self.rightCalloutAccessoryView = button;
    }
    return self;
}

- (void)setAnnotation:(id<MKAnnotation>)annotation {
    [super setAnnotation:annotation];
    [self setNeedsDisplay];
}

- (BKStationViewModel *)viewModel {
    return (BKStationViewModel *)self.annotation;
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
