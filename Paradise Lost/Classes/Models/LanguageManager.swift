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
    
    class func setAppLanguage() {
        if let lang = NSUserDefaults.standardUserDefaults().objectForKey("language") {
            language = lang as! String
        } else {
            language = "en" // default value
        }
    }
    
    class func getAppLanguageDict() -> NSDictionary? {
        if let filename = NSBundle.mainBundle().pathForResource("Language", ofType: "plist") {
            return NSDictionary(contentsOfFile: filename)
        } else {
            return nil
        }
    }
    
    class func getAppLanguageString(key: String) -> String {
        guard let appDict = getAppLanguageDict() else {
            return language == "en" ? "Null String" : "空字符串"
        }
        if let str = appDict.objectForKey(language)?.objectForKey(key) {
            return (str as! String)
        } else {
            return "Null"
        }
    }
}
