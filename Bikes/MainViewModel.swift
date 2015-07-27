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
    let refreshStationsAction: Action<Void, Array<StationViewModel>, NSError>!

    var stationViewModels: Array<StationViewModel>?

    override init() {
        refreshStationsAction = Action<Void, Array<StationViewModel>, NSError> { _ in
            return APIClient.readStations()
                |> map { stations in stations.map { station in StationViewModel(station: station) } }
        }
    }
}