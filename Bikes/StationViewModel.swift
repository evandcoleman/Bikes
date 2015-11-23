//
//  StationViewModel.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

class StationViewModel: ViewModel {
    private let station: Station
    let name: String
    let status: String
    let statusColor: UIColor
    let openDocks: String
    let bikes: String
    let distance: String
    let coordinate: CLLocationCoordinate2D
    let annotation: StationAnnotation

    private let fillPercentage: Double

    init(station: Station) {
        self.station = station
        self.name = station.name!
        self.status = station.status!.statusText()
        self.openDocks = "\(station.openDocks!)"
        self.bikes = "\(station.bikes!)"
        self.distance = NSString(format: "%0.2f mi", station.distance! * 0.000621371) as String
        self.coordinate = CLLocationCoordinate2D(latitude: station.latitude!, longitude: station.longitude!)

        var fillPercentage: Double = 0
        if station.bikes > 0 || station.openDocks > 0 {
            fillPercentage = (Double)(station.openDocks! / station.totalDocks!) * 100.0
        }
        self.fillPercentage = fillPercentage

        if fillPercentage <= 10 {
            self.statusColor = UIColor.bikes_red()
        } else if fillPercentage > 10 && fillPercentage <= 40 {
            self.statusColor = UIColor.bikes_orange()
        } else {
            self.statusColor = UIColor.bikes_green()
        }

        self.annotation = StationAnnotation(coordinate: self.coordinate, statusColor: self.statusColor, title: station.name!, subtitle: "\(station.bikes!) Bikes, \(station.openDocks!) Docks")
    }
}

@objc class StationAnnotation: NSObject, MKAnnotation {
    let coordinate: CLLocationCoordinate2D
    let title: String?
    let subtitle: String?
    let statusColor: UIColor

    init(coordinate: CLLocationCoordinate2D, statusColor: UIColor, title: String, subtitle: String) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.statusColor = statusColor
    }
}