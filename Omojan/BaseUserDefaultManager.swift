//
//  BaseUserDefaultManager.swift
//  Omojan
//
//  Created by naoyashiga on 2015/10/04.
//  Copyright © 2015年 naoyashiga. All rights reserved.
//

import Foundation

class BaseUserDefaultManager: NSObject {
    static let ud = NSUserDefaults.standardUserDefaults()
    static var counter = 0
    
    static func mySetCounter(keyName: String){
        
        if ud.objectForKey(keyName) == nil {
            ud.setObject(0, forKey: keyName)
        } else {
            counter = ud.integerForKey(keyName)
        }
    }
    
    static func countUp(keyName: String){
        counter = counter + 1
        
        ud.setInteger(counter, forKey: keyName)
    }
}