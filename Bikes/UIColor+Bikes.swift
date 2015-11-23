//
//  UIColor+Bikes.swift
//  Bikes
//
//  Created by Evan Coleman on 11/23/15.
//  Copyright © 2015 Evan Coleman. All rights reserved.
//

import UIKit

extension UIColor {

    public static func bikes_red() -> UIColor {
        return UIColor.colorFromRGB(255, green: 60, blue: 60)
    }

    public static func bikes_orange() -> UIColor {
        return UIColor.colorFromRGB(255, green: 165, blue: 0)
    }

    public static func bikes_green() -> UIColor {
        return UIColor.colorFromRGB(105, green: 255, blue: 102)
    }

    // MARK: Helpers

    public static func colorFromRGB(red: Int, green: Int, blue: Int) -> UIColor {
        // TODO: Are these casts necessary?
        return UIColor(red: (CGFloat)(red / 255), green: (CGFloat)(green / 255), blue: (CGFloat)(blue / 255), alpha: 1)
    }
}
