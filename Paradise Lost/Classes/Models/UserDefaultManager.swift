//
//  UserDefaultManager.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/26/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class UserDefaultManager {
    
    enum UserKey: String {
        case tzfeHighScore      // Int      // the highest score
        case tzfeScoreRecord    // Int      // current score
        case tzfeTilesRecord    // [Int]    // current tiles position
        case barCodeSoundOn     // Bool     // if open sound
        case barCodeVibraOn     // Bool     // if open vibra
        case sudokuNumber       // Int      // the number of sudoku puzzle
        case sudokuUserGrid     // [:]      // user sudoku puzzles
    }
    
    class func registerDefaultsFromSettingsBundle() {
        guard let settingsBundle = Bundle.main.path(forResource: "Settings", ofType: "bundle") else {
            return
        }
        guard let settings = NSDictionary(contentsOfFile: settingsBundle + "/Root.plist") else {
            return
        }
        guard let preferences = settings.object(forKey: "PreferenceSpecifiers") as? Array<NSDictionary> else {
            return
        }
        // get the key and value
        var defaultsToRegister = [String : AnyObject].init(minimumCapacity: preferences.count)
        for prefSpec in preferences {
            guard let key = (prefSpec as NSDictionary).object(forKey: "Key") as? String else {
                continue
            }
            guard let value = (prefSpec as NSDictionary).object(forKey: "DefaultValue") as? String else {
                continue
            }
            defaultsToRegister.updateValue(value as AnyObject, forKey: key)
        }
        UserDefaults.standard.register(defaults: defaultsToRegister)
        UserDefaults.standard.synchronize()
    }
    
    fileprivate class func objectFromKeyString(_ key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    class func objectFromKeyEnum(_ key: UserKey) -> Any? {
        return objectFromKeyString(key.rawValue)
    }
    
    fileprivate class func setObject(_ value: AnyObject?, forKeyString key: String) {
        let defaults = UserDefaults()
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    class func setObject(_ value:AnyObject?, forKeyEnum key: UserKey) {
        setObject(value, forKeyString: key.rawValue)
    }
}
