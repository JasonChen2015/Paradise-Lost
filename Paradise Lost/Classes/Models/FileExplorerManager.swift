//
//  FileExplorer.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class FileExplorerManager {
    // singleton
    static let shareInstance = FileExplorerManager()
    
    /// document directory, i.e. ~/Documents
    var documentDir = ""
    /// file manager
    var fileManager = FileManager.default
    
    // MARK: self attribute
    
    init() {
        var paths = NSSearchPathForDirectoriesInDomains(
            .documentDirectory, .userDomainMask, true)
        if paths.count > 0 {
            self.documentDir = paths[0] as String
        }
    }
    
    func getHomeDirectory() -> String {
        return NSHomeDirectory()
    }
    
    // MARK: file attributes
    
    /**
     return all the contents under the folder
     - parameter absolutePath: the absolute path of file
     - returns: an NSArray of all contents from the provided path
    */
    func getFileListFromFolder(_ absolutePath: String) -> [String] {
        if getFileType(absolutePath) == .folder {
            do {
                let filelist = try fileManager.contentsOfDirectory(atPath: absolutePath)
                return filelist
            } catch {
                return []
            }
        } else {
            return []
        }
    }
    
    /**
     return all the contents under the folder recursively
     - parameter absolutePath: the absolute path of file
     - returns: an NSArray of all contents and subpaths recursively from the provided
     path
     
     Notes: This may be very expensive to compute for deep filesystem hierarchies,
     and should probably be avoided.
     */
    func getFileListFromFolderRecursive(_ absolutePath: String) -> [String] {
        if getFileType(absolutePath) == .folder {
            if let fileList = fileManager.subpaths(atPath: absolutePath) {
                return fileList
            } else {
                return []
            }
        } else {
            return []
        }
    }
    
    /**
     judge if a file or a folder exists
     - parameter absolutePath: the absolute path of file
     - returns: true while the file exists
     
     Notes: Attempting to predicate behavior based on the current state of the
     filesystem or a particular file on the filesystem is encouraging odd
     behavior in the face of filesystem race conditions.It's far better to
     attempt an operation and handle the error gracefully than it is to
     try to figure out ahead of time whether the operation will succeed.
     */
    func isFileOrFolderExist(_ absolutePath: String) -> Bool {
        return fileManager.fileExists(atPath: absolutePath)
    }
    
    // enum that defines the type of file
    enum FileType {
        case folder
        case file
        case none
    }

    /**
     get type of the file
     - parameter absolutePath: the absolute path of file
     - returns: a value of enum Type that indicates file type
     
     Notes: Attempting to predicate behavior based on the current state of the
     filesystem or a particular file on the filesystem is encouraging odd
     behavior in the face of filesystem race conditions.It's far better to
     attempt an operation and handle the error gracefully than it is to
     try to figure out ahead of time whether the operation will succeed.
     */
    func getFileType(_ absolutePath: String) -> FileType {
        var isDir : ObjCBool = true
        if fileManager.fileExists(atPath: absolutePath, isDirectory: &isDir) {
            if isDir.boolValue {
                // exists and is a folder
                return .folder
            } else {
                // exists but is a file
                return .file
            }
        } else {
            // file not exists
            return .none
        }
    }
    
    /*
    // May be no use
    enum FileAttributes {
        case ownerAccountName
        case creationDate
        case modificationDate
        case size
        case groupOwnerAccountName
        case hfsTypeCode
        case type
        case referenceCount
        case systemFileNumber
        case hfsCreatorCode
        case posixPermissions
        case groupOwnerAccountID
        case ownerAccountID
        case systemNumber
        case extensionHidden
        
        var value: String {
            switch self {
            case .ownerAccountName:
                return FileAttributeKey.ownerAccountName.rawValue
            case .creationDate:
                return FileAttributeKey.creationDate.rawValue
            case .modificationDate:
                return FileAttributeKey.modificationDate.rawValue
            case .size:
                return FileAttributeKey.size.rawValue
            case .groupOwnerAccountName:
                return FileAttributeKey.groupOwnerAccountName.rawValue
            case .hfsTypeCode:
                return FileAttributeKey.hfsTypeCode.rawValue
            case .type:
                return FileAttributeKey.type.rawValue
            case .referenceCount:
                return FileAttributeKey.referenceCount.rawValue
            case .systemFileNumber:
                return FileAttributeKey.systemFileNumber.rawValue
            case .hfsCreatorCode:
                return FileAttributeKey.hfsCreatorCode.rawValue
            case .posixPermissions:
                return FileAttributeKey.posixPermissions.rawValue
            case .groupOwnerAccountID:
                return FileAttributeKey.groupOwnerAccountID.rawValue
            case .ownerAccountID:
                return FileAttributeKey.ownerAccountID.rawValue
            case .systemNumber:
                return FileAttributeKey.systemNumber.rawValue
            case .extensionHidden:
                return FileAttributeKey.extensionHidden.rawValue
            }
        }
     }
     
     func getAttributeOfAFileOrFoloder(forKey: FileAttributes) -> AnyObject {
     }
    */
    
    /**
     get attributes of a file or a folder
     - parameter absolutePath: the absolute path of file
     - returns: an NSDictionary of key/value pairs containing the attributes of
     the item at the path in question
     */
    func getAttributesOfFileOrFolder(_ absolutePath: String) -> [AnyHashable: Any]? {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: absolutePath)
            return attributes
        } catch {
            return [:]
        }
    }
    
    /*
    // May be no use
    enum FileSystemAttributes {
        case freeNodes
        case nodes
        case size
        case number
        case freeSize

        var value: String {
            switch self {
            case .freeNodes:
                return FileAttributeKey.systemFreeNodes.rawValue
            case .nodes:
                return FileAttributeKey.systemNodes.rawValue
            case .size:
                return FileAttributeKey.systemSize.rawValue
            case .number:
                return FileAttributeKey.systemNumber.rawValue
            case .freeSize:
                return FileAttributeKey.systemFreeSize.rawValue
            }
        }
    }
    */
    
    /**
     rename a file of absolute path to a new name
     - parameter absolutePath: the absolute path of file
     - parameter newName: a string of new name (can not contain '/')
     - returns: true while file is renamed
     */
    func renameFile(_ absolutePath: String, newName:String) -> Bool {
        if !isFileOrFolderExist(absolutePath) {
            // no file can be renamed
            return false
        }
        let dir = NSURL(fileURLWithPath: absolutePath).deletingLastPathComponent
        let toFullPath = "\(dir!.path)/\(newName)"
        if isFileOrFolderExist(toFullPath) {
            return false
        }
        do {
            try fileManager.moveItem(atPath: absolutePath, toPath: toFullPath)
            return true
        } catch {
            return false
        }
    }
    
    // MARK: file create and delete
    
    /**
     create a file at the indicated file path
     - parameter absolutePath: the absolute path of file
     - returns: true while the file is created, if file alrealdy exists then returns
     false
    */
    func createFile(_ absolutePath: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            return false
        } else {
            return fileManager.createFile(atPath: absolutePath, contents: nil, attributes: [:])
        }
    }
    
    /**
     create a file with path whatever the directory is exists
     - parameter absolutePath: the absolute path of file
     - returns: true while the file is created
     */
    func createFileWithDirectory(_ absolutePath: String) -> Bool {
        let dir = NSURL(fileURLWithPath: absolutePath).deletingLastPathComponent
        if !isFileOrFolderExist(dir!.path) {
            do {
                try fileManager.createDirectory(at: dir!, withIntermediateDirectories: true, attributes: [:])
            } catch {
                return false
            }
        }
        return createFile(absolutePath)
    }
    
    /**
     create a directory at the indicated filepath
     - parameter absolutePath: the absolute path of file
     - returns: true while the directory is created, if directory alrealdy exists then
     returns false
     */
    func createDirectory(_ absolutePath: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            return false
        } else {
            do {
                try fileManager.createDirectory(atPath: absolutePath, withIntermediateDirectories: true, attributes: [:])
            } catch {
                return false
            }
            return isFileOrFolderExist(absolutePath)
        }
    }
    
    /**
     remove a file at the indicated file path
     - parameter absolutePath: the absolute path of file
     - returns: true while the file is removed
     */
    func removeFileOrFolder(_ absolutePath: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            do {
                try fileManager.removeItem(atPath: absolutePath)
            } catch {
                return false
            }
            return !isFileOrFolderExist(absolutePath)
        } else {
            // file or folder invalid
            return false
        }
    }
    
    /**
     move file or Folder from path to path
     - parameter fromFullPath: the path where the file or folder is in
     - parameter toFullPath: the path where the file or folder will be in
     - parameter willCover: if true then move the file or folder whatever it exists in the destination path
     - returns: return true while the file is moved
     
     Notes: If move the file(folder) to cover a foler(file) of , it would not success.
     */
    func moveFileOrFolder(fromFullPath: String, toFullPath:String, willCover: Bool) -> Bool {
        if !isFileOrFolderExist(fromFullPath) {
            // no file can be moved
            return false
        }
        if isFileOrFolderExist(toFullPath) {
            if !willCover {
                return false
            } else {
                if getFileType(fromFullPath) != getFileType(toFullPath) {
                    return false
                }
                if !removeFileOrFolder(toFullPath) {
                    return false
                }
            }
        } else {
            let _ = createDirectory((NSURL(fileURLWithPath: toFullPath).deletingLastPathComponent?.path)!)
        }
        // move file
        do {
            try fileManager.moveItem(atPath: fromFullPath, toPath: toFullPath)
        } catch {
            return false
        }
        return isFileOrFolderExist(toFullPath)
    }
    
    /**
     copy file or Folder from path to path
     - parameter fromFullPath: the path where the file or folder is in
     - parameter toFullPath: the path where the file or folder will be in
     - returns: return true while the file is copied
     */
    func copyFileOrFolder(fromFullPath: String, toFullPath:String) -> Bool {
        if !isFileOrFolderExist(fromFullPath) {
            // no file can be moved
            return false
        }
        var newPath: String = "\(toFullPath)"
        if isFileOrFolderExist(toFullPath) {
            newPath = "\(newPath)-copy"
        }
        if !createDirectory((NSURL(fileURLWithPath: newPath).deletingLastPathComponent?.path)!) {
            return false
        }
        // copy file
        do {
            try fileManager.copyItem(atPath: fromFullPath, toPath: newPath)
        } catch {
            return false
        }
        return isFileOrFolderExist(newPath)
    }
    
    // MARK: write data to file using UTF-8
    
    /**
     write data appended to a file
     - parameter absolutePath: the absolute path of file
     - parameter contents: the data that you will write of
     - returns: true while the data is written
     */
    func appendToFile(_ absolutePath: String, contents: String) -> Bool {
        if getFileType(absolutePath) == .file {
            if fileManager.isWritableFile(atPath: absolutePath) {
                let fileHandle : FileHandle = FileHandle(forWritingAtPath: absolutePath)!
                fileHandle.seekToEndOfFile()
                fileHandle.write(contents.data(using: String.Encoding.utf8)!)
                fileHandle.closeFile()
                return true
            } else {
                // can not read
                return false
            }
        } else {
            // it's not a file
            return false
        }
    }
    
    /**
     write data cover to a file
     - parameter absolutePath: the absolute path of file
     - parameter contents: the data that you will write of
     - returns: true while the data is written
     */
    func coverToFile(_ absolutePath: String, contents: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            do {
                try contents.write(toFile: absolutePath, atomically: false, encoding: String.Encoding.utf8)
                return true
            } catch {
                return false
            }
        } else {
            // file invalid
            return false
        }
    }
    
    /**
     get data from file with UTF-8 coding
     - parameter filePath: the path of a file includes directory and filename
     - returns: content in UTF-8 of the file
     */
    func getUTF8FileContent(_ fullPath: String) -> String {
        var content: String
        do {
            content = try String(contentsOf: URL(fileURLWithPath: fullPath), encoding: String.Encoding.utf8)
        } catch {
            return ""
        }
        return content
    }
}
