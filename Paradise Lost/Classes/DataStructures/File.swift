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
    var createDate: Date = Date(timeIntervalSince1970: 0)
    var modifyDate: Date = Date(timeIntervalSince1970: 0)
    
    // suitable for nil
    init() {
    }
    
    init(path: String, name: String) {
        self.path = path
        self.name = name
    }
    
    init(absolutePath: String) {
        let url = URL(fileURLWithPath: absolutePath)
        self.name = url.lastPathComponent
        let n = absolutePath.characters.count - name.characters.count - 1 // '/'
        self.path = absolutePath.substring(to: absolutePath.characters.index(absolutePath.startIndex, offsetBy: n))
    }
    
    mutating func getExtensionsFromName() {
        if name.characters.first != "." { // handle invisible file under unix
            let temp = name.components(separatedBy: ".")
            self.extensions = (temp.count == 2) ? temp[1] : ""
        }
    }
    
    mutating func changeName(_ newName: String) {
        self.name = newName
    }
    
    mutating func setAttributes() {
        if let attr = FileExplorerManager().getAttributesOfFileOrFolder(getFullPath()) {
            if let tsize = attr[FileAttributeKey.size] {
                size = tsize as! Int
            }
            if let tcreateDate = attr[FileAttributeKey.creationDate] {
                createDate = tcreateDate as! Date
            }
            if let tmodifyDate = attr[FileAttributeKey.modificationDate] {
                modifyDate = tmodifyDate as! Date
            }
        }
    }
    
    func getFullPath() -> String {
        if name == "" {
            return ""
        }
        return path + "/" + name 
    }
}
