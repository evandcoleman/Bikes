//
//  ViewModel.swift
//  Bikes
//
//  Created by Evan Coleman on 7/23/15.
//  Copyright (c) 2015 Evan Coleman. All rights reserved.
//

import Foundation
import ReactiveCocoa
import ObjectiveC

private var activeAssociationKey: UInt8 = 0

protocol ViewModel {
    var active: MutableProperty<Bool>! { get }

    var didBecomeActiveSignal: SignalProducer<ViewModel, NoError> { get }
    var didBecomeInactiveSignal: SignalProducer<ViewModel, NoError> { get }
}

extension ViewModel {
    var active: MutableProperty<Bool>! {
        guard let ret = objc_getAssociatedObject(self as? AnyObject, &activeAssociationKey) as? MutableProperty<Bool> else {
            let ret = MutableProperty<Bool>(false)
            objc_setAssociatedObject(self as? AnyObject, &activeAssociationKey, ret, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            return ret
        }
        return ret
    }

    var didBecomeActiveSignal: SignalProducer<ViewModel, NoError> {
        return self.active.producer
            .filter { active in active }
            .map { _ in self }
    }
    var didBecomeInactiveSignal: SignalProducer<ViewModel, NoError> {
        return self.active.producer
            .filter { active in !active }
            .map { _ in self }
    }
}