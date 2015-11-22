//
//  MainViewModel.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import ReactiveCocoa
import SwiftLocation

class MainViewModel: ViewModel {
    let refreshStationsAction: Action<Bool, Array<StationViewModel>, NSError>!
    let stationViewModels: MutableProperty<Array<StationViewModel>>!

    init() {
        refreshStationsAction = Action<Bool, Array<StationViewModel>, NSError> { _ in
            return APIClient.readStations()
                .flatMap(.Concat, transform: { (stations: Array<Station>) -> SignalProducer<Array<Station>, NSError> in
                    return SwiftLocation.shared.rac_currentLocation()
                        .map({ location in
                            return stations
                                .map({ (var station: Station) -> Station in
                                    station.distance = location.distanceFromLocation(station.location())
                                    return station
                                })
                                .sort({ (station1, station2) -> Bool in
                                    return station1.distance < station2.distance
                                })
                        })
                })
                .map { stations in stations.map { station in StationViewModel(station: station) } }
        }

        stationViewModels = MutableProperty<Array<StationViewModel>>([])
        stationViewModels <~ refreshStationsAction.values

        self.didBecomeActiveSignal
            .startWithNext({ next in
                if let viewModel = next as? MainViewModel {
                    viewModel.refreshStationsAction.apply(false).start()
                }
            })
    }
}