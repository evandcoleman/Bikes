//
//  ViewModel.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import ReactiveCocoa

class ViewModel {
    let active: MutableProperty<Bool>! = MutableProperty<Bool>(false)

    private(set) lazy var didBecomeActiveSignal: SignalProducer<ViewModel, NoError> = { [unowned self] in
        return self.active.producer
            |> filter { active in active }
            |> map { _ in self }
    }()
    private(set) lazy var didBecomeInactiveSignal: SignalProducer<ViewModel, NoError> = { [unowned self] in
        return self.active.producer
            |> filter { active in !active }
            |> map { _ in self }
    }()
}