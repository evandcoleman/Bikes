//
//  SwiftLocation.swift
//  Bikes
//
//  Created by Evan Coleman on 11/19/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import SwiftLocation
import ReactiveCocoa

extension SwiftLocation {
    func rac_currentLocation() -> SignalProducer<CLLocation, NSError> {
        return SignalProducer<CLLocation, NSError> { s, _ in
            let sink = s;
            do {
                try self.currentLocation(Accuracy.Neighborhood, timeout: 20, onSuccess: { (location) in
                    sendNext(sink, location!)
                    sendCompleted(sink)
                }) { (error) in
                    sendError(sink, error!)
                }
            } catch _ { }
        }
    }
}
