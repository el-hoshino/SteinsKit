//
//  Observable.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/03/21.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

public protocol Observable {
    
    associatedtype Value
    
    func runWithLatestValue (_ execution: (Value) -> Void)
    
    func map <NewValue> (_ transform: @escaping (Value) -> NewValue) -> AnyObservable<NewValue>
    
    func beObserved <Observer: AnyObject> (by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void)
    func beObserved <Observer: AnyObject> (by observer: Observer, _ method: ExecutionMethod, onChanged handler: @escaping (Observer, Value) -> Void)
    func beObserved <Observer: AnyObject> (by observer: Observer, disposer: AnyObject?, onChanged handler: @escaping (Observer, Value) -> Void)
    func beObserved <Observer: AnyObject> (by observer: Observer, _ method: ExecutionMethod, disposer: AnyObject?, onChanged handler: @escaping (Observer, Value) -> Void)
    
}
