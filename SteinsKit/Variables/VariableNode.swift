//
//  VariableNode.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/04/17.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

protocol VariableNode {
    var isObservationsEmpty: Bool { get }
}

struct VariableNodeContainer {
    private let hashObject = NSObject()
    let node: VariableNode
}

extension VariableNodeContainer {
    
    var isObservationsEmpty: Bool {
        return node.isObservationsEmpty
    }
    
}

extension VariableNodeContainer: Equatable {
    
    static func == (lhs: VariableNodeContainer, rhs: VariableNodeContainer) -> Bool {
        return lhs.hashObject === rhs.hashObject
    }
    
}

extension VariableNodeContainer: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(hashObject)
    }
    
}
