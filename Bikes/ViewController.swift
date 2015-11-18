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

        let appear = self.rac_signalForSelector(Selector("viewDidAppear:")).toSignalProducer().map { _ in true }.catch { _ in SignalProducer<Bool, NoError>.empty }
        let disappear = self.rac_signalForSelector(Selector("viewWillDisappear:")).toSignalProducer().map { _ in false }.catch { _ in SignalProducer<Bool, NoError>.empty }
        let presented = SignalProducer<SignalProducer<Bool, NoError>, NoError>(values: [appear, disappear]).flatten(FlattenStrategy.Merge)

        let currentState = SignalProducer<Bool, NoError>(value: (UIApplication.sharedApplication().applicationState == .Active))
        let didBecomeActive = NSNotificationCenter.defaultCenter().rac_notifications(name: UIApplicationDidBecomeActiveNotification, object: nil).map { _ in true }
        let willResignActive = NSNotificationCenter.defaultCenter().rac_notifications(name: UIApplicationWillResignActiveNotification, object: nil).map { _ in false }
        let appActive = SignalProducer<SignalProducer<Bool, NoError>, NoError>(values: [currentState, didBecomeActive, willResignActive]).flatten(FlattenStrategy.Merge)

        combineLatest(presented, appActive)
            .map { presented, active in presented && active }
            .start(next: { [weak self] active in
                if let viewModel = self?.viewModel {
                    viewModel.active.value = active
                }
            })
    }
}