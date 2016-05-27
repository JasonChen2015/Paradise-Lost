//
//  UserDefaultManager.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/26/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class UserDefaultManager {
    
    enum UserKey {
        case TZFEHighScore      // Int
        case TZFEScoreRecord    // Int
        case TZFETilesRecord    // [Int]
        
        var value: String {
            switch self {
            case .TZFEHighScore:
                return "TZFEHighScore"
            case .TZFEScoreRecord:
                return "TZFEScoreRecord"
            case .TZFETilesRecord:
                return "TZFETilesRecord"
            }
        }
    }
    
    class func valueFromKeyString(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func valueFromKeyEnum(key: UserKey) -> AnyObject? {
        return valueFromKeyString(key.value)
    }
    
    class func setValue(value: AnyObject?, forKeyString key: String) {
        let defaults = NSUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setValue(value:AnyObject?, forKeyEnum key: UserKey) {
        setValue(value, forKeyString: key.value)
    }
}
