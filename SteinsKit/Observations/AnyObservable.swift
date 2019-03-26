//
//  AnyObservable.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/03/26.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

// Type-Erasure for Observable
// Reference: https://qiita.com/omochimetaru/items/5d26b95eb21e022106f0#type-erasure-継承-box-方式
private class AnyObservableBox<Value> {
    
    func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> AnyObservable<NewValue> {
        fatalError()
    }
    
    func beObserved<Observer>(by observer: Observer,
                              onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        fatalError()
    }
    
    func beObserved<Observer>(by observer: Observer,
                              _ method: ExecutionMethod,
                              onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        fatalError()
    }
    
}

private final class ObservableBox<O: Observable>: AnyObservableBox<O.Value> {
    
    private let base: O
    
    init(_ base: O) {
        self.base = base
    }
    
    override func map<NewValue>(_ transform: @escaping (O.Value) -> NewValue) -> AnyObservable<NewValue> {
        return base.map(transform)
    }
    
    override func beObserved<Observer>(by observer: Observer,
                                       onChanged handler: @escaping (Observer, O.Value) -> Void) where Observer : AnyObject {
        return base.beObserved(by: observer, onChanged: handler)
    }
    
    override func beObserved<Observer>(by observer: Observer,
                                       _ method: ExecutionMethod,
                                       onChanged handler: @escaping (Observer, O.Value) -> Void) where Observer : AnyObject {
        return base.beObserved(by: observer, method, onChanged: handler)
    }
    
}

public struct AnyObservable<Value> {
    
    private let box: AnyObservableBox<Value>
    
    init <O: Observable> (_ base: O) where O.Value == Value {
        box = ObservableBox<O>(base)
    }
    
}

extension AnyObservable: Observable {
    
    public func map<NewValue>(_ transform: @escaping (Value) -> NewValue) -> AnyObservable<NewValue> {
        return box.map(transform)
    }
    
    public func beObserved<Observer>(by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, onChanged: handler)
    }
    
    public func beObserved<Observer>(by observer: Observer, _ method: ExecutionMethod, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        return box.beObserved(by: observer, method, onChanged: handler)
    }
    
}
