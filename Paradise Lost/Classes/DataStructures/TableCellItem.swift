//
//  CellItem.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

struct TableCellItem {
    var name: String
    var segueId: String
    var needNavigation: Bool
    
    init(name: String, segueId: String, needNavigation: Bool) {
        self.name = name
        self.segueId = segueId
        self.needNavigation = needNavigation
    }
}

class TableCellItemManager {
    class func itemsFromPlist(name: String) -> [TableCellItem] {
        var items: [TableCellItem] = []
        guard let itemsPath = NSBundle.mainBundle().pathForResource(name, ofType: "plist") else {
            return []
        }
        guard let dict = NSDictionary(contentsOfFile: itemsPath) else {
            return []
        }
        for index in 1...dict.count {
            if let info = dict.objectForKey("\(index)") as? NSDictionary {
                let titleURL = info.objectForKey("name") as! String
                let item = TableCellItem(
                    name: LanguageManager.getAppLanguageString(titleURL),
                    segueId: info.objectForKey("segueId") as! String,
                    needNavigation: info.objectForKey("needNavigation") as! Bool)
                items.append(item)
            }
        }
        return items
    }
    
    class func nameArrayFromItems(items: [TableCellItem]) -> [String] {
        var itemNames: [String] = []
        for index in 0...(items.count - 1) {
            itemNames.append(items[index].name)
        }
        return itemNames
    }
    
    class func classNameFromItems(items: [TableCellItem], atIndex index: Int) -> String {
        /*
         String of class in Swift is as format product_module_name.class_name
         where product_module_name is based on product_name, but any nonaplhanumeric
         characters in it will be replaced with underscore(_).
         
         refer: "Using Swift with Cocoa and Objective-C"
         */
        
        let appName = NSBundle.mainBundle().objectForInfoDictionaryKey("CFBundleName") as! String
        let moduleName = appName.stringByReplacingOccurrencesOfString(" ", withString: "_")
        let className = "\(moduleName).\(items[index].segueId)"
        
        return className
    }
    
    class func needNavigationFromItems(items: [TableCellItem], atIndex index:Int) -> Bool {
        return items[index].needNavigation
    }
}
