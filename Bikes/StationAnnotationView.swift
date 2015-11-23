//
//  StationAnnotationView.swift
//  Bikes
//
//  Created by Evan Coleman on 11/23/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import UIKit
import MapKit

class StationAnnotationView: MKAnnotationView {

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clearColor()
        self.layer.shadowRadius = 3.0;
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowOffset = CGSizeMake(0, -1);
        self.layer.shouldRasterize = true;
    }

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func drawRect(rect: CGRect) {
        guard let annotation = self.annotation as? StationAnnotation else {
            return
        }

        // TODO: Are these casts necessary?
        let path = UIBezierPath(arcCenter: CGPoint(x: CGRectGetWidth(rect) / 2, y: 10), radius: 8, startAngle: (CGFloat)(5 * M_PI / 6), endAngle: (CGFloat)(M_PI / 6), clockwise: true)
        path.addLineToPoint(CGPoint(x: CGRectGetWidth(rect) / 2, y: CGRectGetMidY(rect)))
        path.closePath()

        annotation.statusColor.setFill()
        path.fill()

        UIColor.whiteColor().setStroke()
        path.lineWidth = 3
        path.stroke()
    }
}
