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
    var name: String
    var path: String
    var extensions: String
    var size: Int?
    var createDate: NSDate?
    var modifyDate: NSDate?
    
    // suitable for nil
    init() {
        self.name = ""
        self.path = ""
        self.extensions = ""
    }
    
    init(name: String, path: String, extensions: String) {
        self.name = name
        self.path = path
        self.extensions = extensions
    }
    
    init(filePath: String, fileName: String) {
        self.path = filePath
        let url = NSURL(fileURLWithPath: fileName)
        self.name = (url.URLByDeletingPathExtension?.lastPathComponent)!
        self.extensions = url.pathExtension!
    }
    
    init(absolutePath: String) {
        let url = NSURL(fileURLWithPath: absolutePath)
        self.name = (url.URLByDeletingPathExtension?.lastPathComponent)!
        self.extensions = url.pathExtension!
        var n = absolutePath.characters.count - name.characters.count - 1 // '/'
        if extensions.characters.count > 0 {
            n = n - extensions.characters.count - 1 // '.'
        }
        self.path = absolutePath.substringToIndex(absolutePath.startIndex.advancedBy(n))
    }
    
    mutating func changeName(newName: String) {
        self.name = newName
    }
    
    mutating func changeExtensions(newExtensions: String) {
        self.extensions = newExtensions
    }
    
    mutating func changeFileName(newFileName: String) {
        let url = NSURL(fileURLWithPath: newFileName)
        self.extensions = url.pathExtension!
        self.name = (url.URLByDeletingPathExtension?.lastPathComponent)!
    }
    
    func getFileName() -> String {
        if extensions == "" {
            return name
        } else {
            return name + "." + extensions
        }
    }
    
    func getFullPath() -> String {
        if name == "" {
            return ""
        }
        return path + "/" + getFileName()
    }
}
