//
//  Delegated.swift
//  Delegated
//
//  Created by Oleg Dreyman on 12/7/2020.
//  Copyright © 2020 Oleg Dreyman. All rights reserved.
//

typealias Delegated = Delegated1

@propertyWrapper
final class Delegated1<Input> {
    
    init() {
        self.callback = { _ in }
    }
    
    private var callback: (Input) -> Void
    
    var wrappedValue: (Input) -> Void {
        return callback
    }
    
    var projectedValue: Delegated1<Input> {
        return self
    }
}

extension Delegated1 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, Input) -> Void
    ) {
        self.callback = { [weak target] input in
            guard let target = target else {
                return
            }
            return callback(target, input)
        }
    }
    
    func manuallyDelegate(with callback: @escaping (Input) -> Void) {
        self.callback = callback
    }
    
    func removeDelegate() {
        self.callback = { _ in }
    }
}

@propertyWrapper
final class Delegated0 {
    
    init() {
        self.callback = { }
    }
    
    private var callback: () -> Void
    
    var wrappedValue: () -> Void {
        return callback
    }
    
    var projectedValue: Delegated0 {
        return self
    }
}

extension Delegated0 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target) -> Void
    ) {
        self.callback = { [weak target] in
            guard let target = target else {
                return
            }
            return callback(target)
        }
    }
    
    func manuallyDelegate(with callback: @escaping () -> Void) {
        self.callback = callback
    }
    
    func removeDelegate() {
        self.callback = { }
    }
}

@propertyWrapper
final class Delegated2<Input1, Input2> {
    
    init() {
        self.callback = { _, _ in }
    }
    
    private var callback: (Input1, Input2) -> Void
    
    var wrappedValue: (Input1, Input2) -> Void {
        return callback
    }
    
    var projectedValue: Delegated2<Input1, Input2> {
        return self
    }
}

extension Delegated2 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, Input1, Input2) -> Void
    ) {
        self.callback = { [weak target] (input1, input2) in
            guard let target = target else {
                return
            }
            return callback(target, input1, input2)
        }
    }
    
    func manuallyDelegate(with callback: @escaping (Input1, Input2) -> Void) {
        self.callback = callback
    }
    
    func removeDelegate() {
        self.callback = { _, _ in }
    }
}

@propertyWrapper
final class Delegated3<Input1, Input2, Input3> {
    
    init() {
        self.callback = { _, _, _ in }
    }
    
    private var callback: (Input1, Input2, Input3) -> Void
    
    var wrappedValue: (Input1, Input2, Input3) -> Void {
        return callback
    }
    
    var projectedValue: Delegated3<Input1, Input2, Input3> {
        return self
    }
}

extension Delegated3 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, Input1, Input2, Input3) -> Void
    ) {
        self.callback = { [weak target] (input1, input2, input3) in
            guard let target = target else {
                return
            }
            return callback(target, input1, input2, input3)
        }
    }
    
    func manuallyDelegate(with callback: @escaping (Input1, Input2, Input3) -> Void) {
        self.callback = callback
    }
    
    func removeDelegate() {
        self.callback = { _, _, _ in }
    }
}

@propertyWrapper
final class Delegated4<Input1, Input2, Input3, Input4> {
    
    init() {
        self.callback = { _, _, _, _ in }
    }
    
    private var callback: (Input1, Input2, Input3, Input4) -> Void
    
    var wrappedValue: (Input1, Input2, Input3, Input4) -> Void {
        return callback
    }
    
    var projectedValue: Delegated4<Input1, Input2, Input3, Input4> {
        return self
    }
}

extension Delegated4 {
    func delegate<Target: AnyObject>(
        to target: Target,
        with callback: @escaping (Target, Input1, Input2, Input3, Input4) -> Void
    ) {
        self.callback = { [weak target] (input1, input2, input3, input4) in
            guard let target = target else {
                return
            }
            return callback(target, input1, input2, input3, input4)
        }
    }
    
    func manuallyDelegate(with callback: @escaping (Input1, Input2, Input3, Input4) -> Void) {
        self.callback = callback
    }
    
    func removeDelegate() {
        self.callback = { _, _, _, _ in }
    }
}
