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
