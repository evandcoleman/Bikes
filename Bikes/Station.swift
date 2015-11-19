//
//  Station.swift
//  Bikes
//
//  Created by Evan Coleman on 7/18/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import ObjectMapper
import CoreLocation

enum StationStatus {
    case Unknown
    case InService
    case OutOfService

    func statusText() -> String {
        switch self {
        case .InService:
            return "In Service"
        case .OutOfService:
            return "Out Of Service"
        default:
            return "Unknown"
        }
    }
}

private class StationStatusTransform: TransformType {
    typealias Object = StationStatus
    typealias JSON = Int

    func transformFromJSON(value: AnyObject?) -> Object? {
        if let val:AnyObject = value {
            if let intVal = val as? Int {
                switch intVal {
                case 1:
                    return .InService
                case 3:
                    return .OutOfService
                default:
                    return .Unknown
                }
            }
        }
        return .Unknown
    }

    func transformToJSON(value: Object?) -> JSON? {
        return nil
    }
}

struct Station: Mappable {
    var ID: Int?
    var name: String?
    var latitude: Double?
    var longitude: Double?
    var status: StationStatus?
    var totalDocks: Int?
    var openDocks: Int?
    var bikes: Int?
    var distance: Double?
    
    init(){}
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    mutating func mapping(map: Map) {
        ID <- map["id"]
        name <- map["stationName"]
        latitude <- map["latitude"]
        longitude <- map["longitude"]
        status <- (map["statusKey"], StationStatusTransform())
        totalDocks <- map["totalDocks"]
        openDocks <- map["availableDocks"]
        bikes <- map["availableBikes"]
    }

    func location() -> CLLocation {
        return CLLocation(latitude: self.latitude!, longitude: self.longitude!)
    }
}

struct StationsResponse: Mappable {
    var stations: Array<Station>?

    init(){}

    init?(_ map: Map) {
        mapping(map)
    }

    mutating func mapping(map: Map) {
        stations <- map["stationBeanList"]
    }
}