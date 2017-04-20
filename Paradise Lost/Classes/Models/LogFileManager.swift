//
//  LogFileManager.swift
//  Paradise Lost
//
//  Created by jason on 30/6/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class LogFileManager {
    class func printLogFile<T>(_ message: T, file: String = #file, method: String = #function, line: Int = #line) {
        let fs = FileExplorerManager.shareInstance
        if fs.documentDir == "" {
            return
        }
        
        // get the file
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let filePath: String = "\(fs.documentDir)/log/\(dateFormatter.string(from: Date())).log"
        if !fs.isFileOrFolderExist(filePath) {
            let _ = fs.createFileWithDirectory(filePath)
        }
        
        // set the log message
        dateFormatter.dateFormat = "HH:mm:ss"
        let timestamp = dateFormatter.string(from: Date())
        let text: String = "<\(timestamp)> \(method)[\((file as NSString).lastPathComponent) \(line)]:\n\(message)\n"
        
        // append to log file
        let _ = fs.appendToFile(filePath, contents: text)
    }
    
    class func deleteLogFile(_ beforeDate: Date) {
        // TODO: get the filelist and check if needs to be deleted then delete it
    }
}
