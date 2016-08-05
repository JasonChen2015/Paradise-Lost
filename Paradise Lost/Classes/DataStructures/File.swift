//
//  File.swift
//  Paradise Lost
//
//  Created by jason on 30/6/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

/**
    e.g. "/var/mobile/Containers/Data/Application/DB4F8A38-59DA-4675-B37B-4AC98E0512E2/Documents/editor/untitled.txt"
    name = "untitled.txt"
    path = "/var/mobile/Containers/Data/Application/DB4F8A38-59DA-4675-B37B-4AC98E0512E2/Documents/editor"
    extensions = "txt"
 */

struct File {
    var name: String = "" {
        didSet {
            getExtensionsFromName()
        }
    }
    var path: String = ""
    var extensions: String = ""
    var size: Int = 0
    var createDate: NSDate = NSDate(timeIntervalSince1970: 0)
    var modifyDate: NSDate = NSDate(timeIntervalSince1970: 0)
    
    // suitable for nil
    init() {
    }
    
    init(path: String, name: String) {
        self.path = path
        self.name = name
    }
    
    init(absolutePath: String) {
        let url = NSURL(fileURLWithPath: absolutePath)
        self.name = (url.lastPathComponent)!
        let n = absolutePath.characters.count - name.characters.count - 1 // '/'
        self.path = absolutePath.substringToIndex(absolutePath.startIndex.advancedBy(n))
    }
    
    mutating func getExtensionsFromName() {
        if name.characters.first != "." {
            let temp = name.componentsSeparatedByString(".")
            self.extensions = (temp.count == 2) ? temp[1] : ""
        }
    }
    
    mutating func changeName(newName: String) {
        self.name = newName
    }
    
    mutating func setAttributes() {
        let attr = FileExplorerManager().getAttributesOfFileOrFolder(getFullPath())
        size = attr![NSFileSize] as! Int
        createDate = attr![NSFileCreationDate] as! NSDate
        modifyDate = attr![NSFileModificationDate] as! NSDate
    }
    
    func getFullPath() -> String {
        if name == "" {
            return ""
        }
        return path + "/" + name 
    }
}
