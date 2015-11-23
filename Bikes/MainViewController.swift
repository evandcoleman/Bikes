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
    @IBOutlet weak var mapViewHeightConstraint: NSLayoutConstraint!
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

        let mapTapGesture = UITapGestureRecognizer()
        mapTapGesture.rac_gestureSignal()
            .toSignalProducer()
            .filter { gesture -> Bool in
                return gesture!.state == UIGestureRecognizerState.Recognized
            }
            .startWithNext { [unowned self] _ in
                // TODO: Figure out why the spring animation isn't working
                UIView.animateWithDuration(0.22, delay: 0, usingSpringWithDamping: 14, initialSpringVelocity: 4, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                    self.mapViewHeightConstraint.constant = self.mapViewHeightConstraint.constant == 0 ? CGRectGetHeight(self.view.bounds) * (1 - self.mapViewHeightConstraint.multiplier) : 0
                    self.view.setNeedsLayout()
                    self.view.layoutIfNeeded()
                    }, completion: nil)
            }
        self.mapView.addGestureRecognizer(mapTapGesture)

        viewModel.stationViewModels.producer
            .startWithNext({ viewModels in
                self.mapView.addAnnotations(viewModels.map({ viewModel in viewModel.annotation }))
                self.tableView.reloadData()
            })
    }

    // MARK: MKMapViewDelegate

    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation.isKindOfClass(StationAnnotation) {
            let annotationView = StationAnnotationView(annotation: annotation, reuseIdentifier: "StationAnnotation")
            annotationView.frame = CGRect(x: 0, y: 0, width: 25, height: 50)
            annotationView.canShowCallout = true

            return annotationView
        }

        return nil
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

