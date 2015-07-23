//
//  MainViewModel.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import ReactiveCocoa

class MainViewModel: ViewModel {
    let refreshStationsAction: Action<AnyObject?, Array<StationViewModel>, NSError>!

    let stationViewModels: Array<StationViewModel>

    override init() {
        self.refreshStationsAction = Action<AnyObject?, Array<StationViewModel>, NSError>(execute: { _ in
            return SignalProducer<Array<StationViewModel>, NSError>()
        })
    }
}