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
        if let lang = NSUserDefaults.standardUserDefaults().objectForKey("language") {
            language = lang as! String
        } else {
            language = "en" // default value
        }
        dict = getAppLanguageDict()
    }
    
    class  func defaultNullString() -> String {
        if language == "en" { return "Null" }
        if language == "ch" { return "空字符串" }
        return "Null"
    }
    
    class func getAppLanguageDict() -> NSDictionary? {
        if let filename = NSBundle.mainBundle().pathForResource("Language", ofType: "plist") {
            return NSDictionary(contentsOfFile: filename)
        } else {
            return nil
        }
    }
    
    class func getAppLanguageString(key: String) -> String {
        if dict != nil {
            if let str = dict!.objectForKey(language)?.objectForKey(key) {
                return (str as! String)
            }
        }
        return defaultNullString()
    }
    
    class func getString(forKey key: String, inSet: String) -> String {
        if dict != nil {
            if let value = dict!.objectForKey(inSet)?.objectForKey(key) {
                if let str = value.objectForKey(language) {
                    return (str as! String);
                }
            }
        }
        return defaultNullString()
    }
}
