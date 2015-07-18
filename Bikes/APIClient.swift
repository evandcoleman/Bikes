//
//  APIClient.swift
//  Bikes
//
//  Created by Evan Coleman on 7/18/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import Alamofire

class APIClient {
    
    class func readStations() {
        Alamofire.request(.GET, "https://www.citibikenyc.com/stations/json")
            .responseJSON { _, _, JSON, _ in
                
            }
    }
}