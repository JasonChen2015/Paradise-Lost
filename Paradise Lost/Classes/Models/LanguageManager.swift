//
//  LanguageManager.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/30/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class LanguageManager {
    
    static var language: String!
    static var dict: NSDictionary?
    
    class func setAppLanguage() {
        if let lang = UserDefaults.standard.object(forKey: "language") as? String {
            language = lang
        } else {
            language = "en" // default value
        }
        dict = getAppLanguageDict()
    }
    
    class  func defaultNullString() -> String {
        if language == "en" { return "Null" }
        if language == "zh" { return "空字符串" }
        return "Null"
    }
    
    class func getAppLanguageDict() -> NSDictionary? {
        if let filename = Bundle.main.path(forResource: "Language", ofType: "plist") {
            return NSDictionary(contentsOfFile: filename)
        } else {
            return nil
        }
    }
    
    class func getAppLanguageString(_ key: String) -> String {
        if dict != nil {
            if let str = (dict!.object(forKey: language) as AnyObject).object(forKey: key) {
                return (str as! String)
            }
        }
        return defaultNullString()
    }
    
    class func getPublicString(forKey key: String) -> String {
        return getString(forKey: key, inSet: "public")
    }
    
    class func getAlertString(forKey key: String) -> String {
        return getString(forKey: key, inSet: "alert")
    }
    
    class func getToolString(forKey key: String) -> String {
        return getString(forKey: key, inSet: "tool")
    }
    
    class func getGameString(forKey key: String) -> String {
        return getString(forKey: key, inSet: "game")
    }
    
    class func getString(forKey key: String, inSet: String) -> String {
        if dict != nil {
            if let value = (dict!.object(forKey: inSet) as AnyObject).object(forKey: key) {
                if let str = (value as AnyObject).object(forKey: language) {
                    return (str as! String);
                }
            }
        }
        return defaultNullString()
    }
}
