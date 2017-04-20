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
    
    enum MainTabType {
        case tool
        case game
        
        var value: String {
            switch self {
            case .tool:
                return "tool"
            case .game:
                return "game"
            }
        }
    }
    
    class func itemsFromPlist(_ name: String, ofType type: MainTabType) -> [TableCellItem] {
        var items: [TableCellItem] = []
        guard let itemsPath = Bundle.main.path(forResource: name, ofType: "plist") else {
            return []
        }
        guard let dict = NSDictionary(contentsOfFile: itemsPath) else {
            return []
        }
        for index in 1...dict.count {
            if let info = dict.object(forKey: "\(index)") as? NSDictionary {
                let titleURL = info.object(forKey: "name") as! String
                let item = TableCellItem(
                    name: LanguageManager.getString(forKey: titleURL, inSet: type.value),
                    segueId: info.object(forKey: "segueId") as! String,
                    needNavigation: info.object(forKey: "needNavigation") as! Bool)
                items.append(item)
            }
        }
        return items
    }
    
    class func nameArrayFromItems(_ items: [TableCellItem]) -> [String] {
        var itemNames: [String] = []
        for index in 0...(items.count - 1) {
            itemNames.append(items[index].name)
        }
        return itemNames
    }
    
    class func classNameFromItems(_ items: [TableCellItem], atIndex index: Int) -> String {
        /*
         String of class in Swift is as format product_module_name.class_name
         where product_module_name is based on product_name, but any nonaplhanumeric
         characters in it will be replaced with underscore(_).
         
         refer: "Using Swift with Cocoa and Objective-C"
         */
        
        let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as! String
        let moduleName = appName.replacingOccurrences(of: " ", with: "_")
        let className = "\(moduleName).\(items[index].segueId)"
        
        return className
    }
    
    class func needNavigationFromItems(_ items: [TableCellItem], atIndex index:Int) -> Bool {
        return items[index].needNavigation
    }
}
