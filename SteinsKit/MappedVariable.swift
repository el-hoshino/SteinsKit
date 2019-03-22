//
//  MappedVariable.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/03/21.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

// TODO: Auto-Generate the code below because `XXVariable`s have the same implementations
public final class MappedVariable<Value> {
    
    private var value: Value {
        didSet { runObservations() }
    }
    
    private var observations: Set<Observation<Value>> = []
    
    private var relatedVariables: [AnyObject] = []
    
    public init(_ value: Value) {
        self.value = value
    }
    
}

extension MappedVariable {
    
    private func runObservations() {
        
        let newValue = value
        
        for observation in observations {
            
            if observation.observerDeinited {
                observations.remove(observation)
                
            } else {
                observation.run(with: newValue)
            }
            
        }
        
    }
    
}

extension MappedVariable {
    
    var currentValue: Value {
        return value
    }
    
    func accept(_ newValue: Value) {
        value = newValue
    }
    
}

extension MappedVariable: Observable {
    
    public func map <NewValue> (_ transform: @escaping (Value) -> NewValue) -> MappedVariable<NewValue> {
        
        let mappedValue = transform(value)
        let mappedVariable = MappedVariable<NewValue>(mappedValue)
        beObserved(by: mappedVariable) { (mappedVariable, value) in
            mappedVariable.accept(transform(value))
        }
        
        relatedVariables.append(mappedVariable)
        
        return mappedVariable
        
    }
    
    public func beObserved <Observer: AnyObject> (by observer: Observer, onChanged handler: @escaping (Observer, Value) -> Void) {
        
        defer { handler(observer, value) }
        
        let observation = Observation(observer: observer, method: .directly, observingAction: handler)
        
        observations.insert(observation)
        
    }
    
    public func beObserved<Observer>(by observer: Observer, _ method: ExecutionMethod, onChanged handler: @escaping (Observer, Value) -> Void) where Observer : AnyObject {
        
        defer { handler(observer, value) }
        
        let observation = Observation(observer: observer, method: method, observingAction: handler)
        
        observations.insert(observation)
        
    }
    
}
