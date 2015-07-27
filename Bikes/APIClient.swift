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
    
    class func readStations() -> SignalProducer<Array<Station>, NSError> {
        return SignalProducer<Array<Station>, NSError> { sink, _ in
            Alamofire.request(.GET, "https://www.citibikenyc.com/stations/json")
                .responseObject { (response: StationsResponse?, error: NSError?) in
                    if let stations = response?.stations {
                        sendNext(sink, stations)
                        sendCompleted(sink)
                    } else {
                        sendError(sink, error!)
                    }
                }
        }
    }
}