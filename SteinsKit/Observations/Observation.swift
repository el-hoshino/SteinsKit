//
//  Observation.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/03/21.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

struct Observation<Value> {
    
    private(set) weak var observer: AnyObject?
    private(set) weak var disposer: AnyObject?
    private let method: ExecutionMethod
    private var action: (Value) -> Void
    
    private let hashObject: NSObject = .init()
    
    init <Observer: AnyObject> (observer: Observer, disposer: AnyObject, method: ExecutionMethod, observingAction: @escaping (Observer, Value) -> Void) {
        
        let action: (Value) -> Void = { [weak observer] value in
            if let observer = observer {
                observingAction(observer, value)
            }
        }
        
        self.observer = observer
        self.disposer = disposer
        self.method = method
        self.action = action
        
    }
    
}

extension Observation {
    
    var canRunObservingAction: Bool {
        return observer != nil && disposer != nil
    }
    
    func run (with value: Value) {
        
        func execute() { action(value) }
        
        switch method {
        case .directly:
            execute()
            
        case .syncOnQueue(let queue):
            queue.sync { execute() }
            
        case .asyncOnQueue(let queue):
            queue.async { execute() }
        }
        
    }
    
}

extension Observation: Equatable {
    
    static func == (lhs: Observation<Value>, rhs: Observation<Value>) -> Bool {
        return lhs.hashObject === rhs.hashObject
    }
    
}

extension Observation: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashObject)
    }
    
}
