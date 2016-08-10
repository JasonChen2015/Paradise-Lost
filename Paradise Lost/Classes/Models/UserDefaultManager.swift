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
        case TZFEHighScore      // Int      // the highest score
        case TZFEScoreRecord    // Int      // current score
        case TZFETilesRecord    // [Int]    // current tiles position
        case BarCodeSoundOn     // Bool     // if open sound
        case BarCodeVibraOn     // Bool     // if open vibra
        case SudokuNumber       // Int      // the number of sudoku puzzle
        case SudokuUserGrid     // [:]      // user sudoku puzzles
        
        var value: String {
            switch self {
            case .TZFEHighScore:
                return "TZFEHighScore"
            case .TZFEScoreRecord:
                return "TZFEScoreRecord"
            case .TZFETilesRecord:
                return "TZFETilesRecord"
            case .BarCodeSoundOn:
                return "BarCodeSoundOn"
            case .BarCodeVibraOn:
                return "BarCodeVibraOn"
            case .SudokuNumber:
                return "SudokuNumber"
            case .SudokuUserGrid:
                return "SudokuUserGrid"
            }
        }
    }
    
    class func registerDefaultsFromSettingsBundle() {
        guard let settingsBundle = NSBundle.mainBundle().pathForResource("Settings", ofType: "bundle") else {
            return
        }
        guard let settings = NSDictionary(contentsOfFile: settingsBundle.stringByAppendingString("/Root.plist")) else {
            return
        }
        guard let preferences = settings.objectForKey("PreferenceSpecifiers") as? Array<NSDictionary> else {
            return
        }
        // get the key and value
        var defaultsToRegister = [String : AnyObject].init(minimumCapacity: preferences.count)
        for prefSpec in preferences {
            guard let key = (prefSpec as NSDictionary).objectForKey("Key") as? String else {
                continue
            }
            guard let value = (prefSpec as NSDictionary).objectForKey("DefaultValue") as? String else {
                continue
            }
            defaultsToRegister.updateValue(value, forKey: key)
        }
        NSUserDefaults.standardUserDefaults().registerDefaults(defaultsToRegister)
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    private class func objectFromKeyString(key: String) -> AnyObject? {
        return NSUserDefaults.standardUserDefaults().objectForKey(key)
    }
    
    class func objectFromKeyEnum(key: UserKey) -> AnyObject? {
        return objectFromKeyString(key.value)
    }
    
    private class func setObject(value: AnyObject?, forKeyString key: String) {
        let defaults = NSUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setObject(value:AnyObject?, forKeyEnum key: UserKey) {
        setObject(value, forKeyString: key.value)
    }
}
