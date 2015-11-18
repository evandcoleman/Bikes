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
        return SignalProducer<Array<Station>, NSError> { s, _ in
            let sink = s;
            Alamofire.request(.GET, "https://www.citibikenyc.com/stations/json")
                .responseObject { (response: Response<StationsResponse, NSError>) in
                    if let stations = response.result.value?.stations {
                        sendNext(sink, stations)
                        sendCompleted(sink)
                    } else {
                        sendError(sink, response.result.error!)
                    }
                }
        }
    }
}