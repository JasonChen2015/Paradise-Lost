//
//  LogFileManager.swift
//  Paradise Lost
//
//  Created by jason on 30/6/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class LogFileManager {
    class func printLogFile<T>(message: T, file: String = #file, method: String = #function, line: Int = #line) {
        let fs = FileExplorerManager.shareInstance
        if fs.documentDir == "" {
            return
        }
        
        // get the file
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let filePath: String = "\(fs.documentDir)/log/\(dateFormatter.stringFromDate(NSDate())).log"
        if !fs.isFileOrFolderExist(filePath) {
            fs.createFileWithDirectory(filePath)
        }
        
        // set the log message
        dateFormatter.dateFormat = "HH:mm:ss"
        let timestamp = dateFormatter.stringFromDate(NSDate())
        let text: String = "<\(timestamp)> \(method)[\((file as NSString).lastPathComponent) \(line)]:\n\(message)\n"
        
        // append to log file
        fs.appendToFile(filePath, contents: text)
    }
    
    class func deleteLogFile(beforeDate: NSDate) {
        // TODO: get the filelist and check if needs to be deleted then delete it
    }
}
