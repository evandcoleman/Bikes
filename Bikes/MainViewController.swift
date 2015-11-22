//
//  ViewController.swift
//  Bikes
//
//  Created by Evan Coleman on 7/18/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import UIKit
import MapKit
import ReactiveCocoa

class MainViewController: ViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let viewModel = self.viewModel as! MainViewModel

        self.rac_signalForSelector(Selector("mapView:didUpdateUserLocation:"))
            .toSignalProducer()
            .map { t -> MKUserLocation in
                let tuple = t as! RACTuple
                return tuple.second as! MKUserLocation
            }
            .combineLatestWith(viewModel.selectedStationViewModel.producer.promoteErrors(NSError))
            .map { (userLocation, selectedViewModel) -> CLLocationCoordinate2D in
                if let stationViewModel = selectedViewModel {
                    return stationViewModel.coordinate
                } else {
                    return userLocation.coordinate
                }
            }
            .startWithNext { [unowned self] coordinate in
                self.mapView.setRegion(MKCoordinateRegionMake(coordinate, MKCoordinateSpanMake(0.005, 0.005)), animated: true)
            }

        viewModel.stationViewModels.producer
            .startWithNext({ viewModels in
                self.tableView.reloadData()
            })
    }

    // MARK: UITableViewDelegate

    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let viewModel = self.viewModel as! MainViewModel
        let selectedViewModel = viewModel.stationViewModels.value[indexPath.row]

        viewModel.selectStationAction.apply(selectedViewModel).start()
    }

    // MARK: UITableViewDataSource

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let viewModel = self.viewModel as! MainViewModel

        if section == 0 {
            return 0
        } else if section == 1 {
            return viewModel.stationViewModels.value.count
        } else {
            return 0
        }
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("StationCell", forIndexPath: indexPath) as! StationCell

        let viewModel = self.viewModel as! MainViewModel
        cell.viewModel = viewModel.stationViewModels.value[indexPath.row]

        return cell;
    }
}

