//
//  APIClient.swift
//  Bikes
//
//  Created by Evan Coleman on 7/18/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Alamofire
import AlamofireObjectMapper
import ReactiveCocoa

class APIClient {
    
    class func readStations() -> Signal<Array<Station>, NSError> {
        let (signal, sink) = Signal<Array<Station>, NSError>.pipe()

        Alamofire.request(.GET, "https://www.citibikenyc.com/stations/json")
            .responseObject { (response: StationsResponse?, error: NSError?) in
                if let stations = response?.stations {
                    sendNext(sink, stations)
                } else {
                    sendError(sink, error!)
                }
            }

        return signal
    }
}