//
//  LazyValue.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/03/25.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

enum Lazy<Value> {
    case uninitialized
    case initialized(Value)
}

extension Lazy {
    
    var value: Value? {
        
        switch self {
        case .uninitialized:
            return nil
            
        case .initialized(let value):
            return value
        }
        
    }
    
}

extension Lazy {
    
    func transformed <NewValue> (by transform: (Value) -> NewValue) -> Lazy<NewValue> {
        
        switch self {
        case .uninitialized:
            return .uninitialized
            
        case .initialized(let value):
            return .initialized(transform(value))
        }
        
    }
    
}
