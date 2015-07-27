//
//  ViewController.swift
//  Bikes
//
//  Created by Evan Coleman on 7/27/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import UIKit
import ReactiveCocoa

class ViewController: UIViewController {
    var viewModel: ViewModel?

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        let appearSignal = self.rac_signalForSelector(Selector("viewDidAppear:")).toSignalProducer() |> map { _ in true }
        let disappearSignal = self.rac_signalForSelector(Selector("viewWillDisappear:")).toSignalProducer() |> map { _ in false }
        let presented = SignalProducer<SignalProducer<Bool, NSError>, NSError>(values: [appearSignal, disappearSignal]) |> flatten(FlattenStrategy.Merge)

        
    }
}