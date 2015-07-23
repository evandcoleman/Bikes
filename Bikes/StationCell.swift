//
//  StationCell.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import UIKit

class StationCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var bikesLabel: UILabel!
    @IBOutlet weak var docksLabel: UILabel!
    
    var viewModel: StationViewModel? {
        didSet {
            nameLabel.text! = viewModel!.name
            distanceLabel.text! = viewModel!.distance
            bikesLabel.text! = viewModel!.bikes
            docksLabel.text! = viewModel!.openDocks
        }
    }
}