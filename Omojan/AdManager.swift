//
//  AdManager.swift
//  Omojan
//
//  Created by naoyashiga on 2015/10/04.
//  Copyright © 2015年 naoyashiga. All rights reserved.
//

import Foundation

final class AdManager: BaseUserDefaultManager {
    
    struct keyName {
        static let adCounter = "adCounter"
    }
    
    struct Cycle {
        static var top = 10
    }
}
