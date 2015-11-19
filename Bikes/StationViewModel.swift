//
//  StationViewModel.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation

class StationViewModel: ViewModel {
    let name: String
    let status: String
    let openDocks: String
    let bikes: String
    let distance: String

    init(station: Station) {
        self.name = station.name!
        self.status = station.status!.statusText()
        self.openDocks = "\(station.openDocks!)"
        self.bikes = "\(station.bikes!)"
        self.distance = NSString(format: "%0.2f mi", station.distance! * 0.000621371) as String
    }
}