//
//  ExecutionMethod.swift
//  SteinsKit
//
//  Created by 史 翔新 on 2019/03/22.
//  Copyright © 2019 Crazism. All rights reserved.
//

import Foundation

public enum ExecutionMethod {
    case directly
    case syncOnQueue(DispatchQueue)
    case asyncOnQueue(DispatchQueue)
}

extension ExecutionMethod {
    
    public static var asyncOnMain: ExecutionMethod {
        return .asyncOnQueue(.main)
    }
    
    public static func asyncOnGlobal(qos: DispatchQoS.QoSClass = .default) -> ExecutionMethod {
        return .asyncOnQueue(.global(qos: qos))
    }
    
}
