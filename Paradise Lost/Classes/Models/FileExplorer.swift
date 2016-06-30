//
//  FileExplorer.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class FileExplorer {
    /// document directory, i.e. ~/Documents
    var documentDir : String? = ""
    /// file manager
    var fileManager = NSFileManager.defaultManager()
    
    // MARK: self attribute
    
    init?() {
        var paths = NSSearchPathForDirectoriesInDomains(
            .DocumentDirectory, .UserDomainMask, true)
        if paths.count > 0 {
            self.documentDir = paths[0] as String
        } else {
            return nil
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
    func getFileListFromFolder(absolutePath: String) -> [String] {
        if getFileType(absolutePath) == .Folder {
            do {
                let filelist = try fileManager.contentsOfDirectoryAtPath(absolutePath)
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
    func getFileListFromFolderRecursive(absolutePath: String) -> [String] {
        if getFileType(absolutePath) == .Folder {
            if let fileList = fileManager.subpathsAtPath(absolutePath) {
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
    func isFileOrFolderExist(absolutePath: String) -> Bool {
        return fileManager.fileExistsAtPath(absolutePath)
    }
    
    // enum that defines the type of file
    enum FileType {
        case Folder
        case File
        case None
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
    func getFileType(absolutePath: String) -> FileType {
        var isDir: ObjCBool = true
        if fileManager.fileExistsAtPath(absolutePath, isDirectory: &isDir) {
            if isDir {
                // exists and is a folder
                return .Folder
            } else {
                // exists but is a file
                return .File
            }
        } else {
            // file not exists
            return .None
        }
    }
    
    enum FileAttributes {
        case OwnerAccountName
        case CreationDate
        case ModificationDate
        case Size
        case GroupOwnerAccountName
        case HFSTypeCode
        case Type
        case ReferenceCount
        case SystemFileNumber
        case HFSCreatorCode
        case PosixPermissions
        case GroupOwnerAccountID
        case OwnerAccountID
        case SystemNumber
        case ExtensionHidden
        
        var value: String {
            switch self {
            case OwnerAccountName:
                return NSFileOwnerAccountName
            case CreationDate:
                return NSFileCreationDate
            case ModificationDate:
                return NSFileModificationDate
            case Size:
                return NSFileSize
            case GroupOwnerAccountName:
                return NSFileGroupOwnerAccountName
            case HFSTypeCode:
                return NSFileHFSTypeCode
            case Type:
                return NSFileType
            case ReferenceCount:
                return NSFileReferenceCount
            case SystemFileNumber:
                return NSFileSystemFileNumber
            case HFSCreatorCode:
                return NSFileHFSCreatorCode
            case PosixPermissions:
                return NSFilePosixPermissions
            case GroupOwnerAccountID:
                return NSFileGroupOwnerAccountID
            case OwnerAccountID:
                return NSFileOwnerAccountID
            case SystemNumber:
                return NSFileSystemNumber
            case ExtensionHidden:
                return NSFileExtensionHidden
            }
        }
    }
    
    /**
     get attributes of a file or a folder
     - parameter absolutePath: the absolute path of file
     - returns: an NSDictionary of key/value pairs containing the attributes of
     the item at the path in question
     */
    func getAttributesOfAFileOrFolder(absolutePath: String) -> [NSObject: AnyObject]? {
        do {
            let attributes = try fileManager.attributesOfItemAtPath(absolutePath)
            return attributes
        } catch {
            return [:]
        }
    }
    
    /*
    // May be no use
    func getAttributeOfAFileOrFoloder(forKey: FileAttributes) -> AnyObject {
    }
    */
    
    enum FileSystemAttributes {
        case FreeNodes
        case Nodes
        case Size
        case Number
        case FreeSize

        var value: String {
            switch self {
            case FreeNodes:
                return NSFileSystemFreeNodes
            case Nodes:
                return NSFileSystemNodes
            case Size:
                return NSFileSystemSize
            case Number:
                return NSFileSystemNumber
            case FreeSize:
                return NSFileSystemFreeSize
            }
        }
    }
    
    /**
     rename a file of absolute path to a new name
     - parameter absolutePath: the absolute path of file
     - parameter newName: a string of new name (can not contain '/')
     - returns: true while file is renamed
     */
    func renameFile(absolutePath: String, newName:String) -> Bool {
        if !isFileOrFolderExist(absolutePath) {
            // no file can be renamed
            return false
        }
        let dir = NSURL(fileURLWithPath: absolutePath).URLByDeletingLastPathComponent
        let toFullPath = "\(dir!.path!)/\(newName)"
        if isFileOrFolderExist(toFullPath) {
            return false
        }
        do {
            try fileManager.moveItemAtPath(absolutePath, toPath: toFullPath)
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
    func createFile(absolutePath: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            return false
        } else {
            return fileManager.createFileAtPath(absolutePath, contents: nil, attributes: [:])
        }
    }
    
    /**
     create a file with path whatever the directory is exists
     - parameter absolutePath: the absolute path of file
     - returns: true while the file is created
     */
    func createFileWithDirectory(absolutePath: String) -> Bool {
        let dir = NSURL(fileURLWithPath: absolutePath).URLByDeletingLastPathComponent
        if !isFileOrFolderExist(dir!.path!) {
            do {
                try fileManager.createDirectoryAtURL(dir!, withIntermediateDirectories: true, attributes: [:])
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
    func createDirectory(absolutePath: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            return false
        } else {
            do {
                try fileManager.createDirectoryAtPath(absolutePath, withIntermediateDirectories: true, attributes: [:])
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
    func removeFileOrFolder(absolutePath: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            do {
                try fileManager.removeItemAtPath(absolutePath)
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
    func moveFileOrFolder(fromFullPath fromFullPath: String, toFullPath:String, willCover: Bool) -> Bool {
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
            createDirectory((NSURL(fileURLWithPath: toFullPath).URLByDeletingLastPathComponent?.path)!)
        }
        // move file
        do {
            try fileManager.moveItemAtPath(fromFullPath, toPath: toFullPath)
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
    func copyFileOrFolder(fromFullPath fromFullPath: String, toFullPath:String) -> Bool {
        if !isFileOrFolderExist(fromFullPath) {
            // no file can be moved
            return false
        }
        var newPath: String = "\(toFullPath)"
        if isFileOrFolderExist(toFullPath) {
            newPath = "\(newPath)-copy"
        }
        if !createDirectory((NSURL(fileURLWithPath: newPath).URLByDeletingLastPathComponent?.path)!) {
            return false
        }
        // copy file
        do {
            try fileManager.copyItemAtPath(fromFullPath, toPath: newPath)
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
    func appendToFile(absolutePath: String, contents: String) -> Bool {
        if getFileType(absolutePath) == .File {
            if fileManager.isWritableFileAtPath(absolutePath) {
                let fileHandle : NSFileHandle = NSFileHandle(forWritingAtPath: absolutePath)!
                fileHandle.seekToEndOfFile()
                fileHandle.writeData(contents.dataUsingEncoding(NSUTF8StringEncoding)!)
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
    func coverToFile(absolutePath: String, contents: String) -> Bool {
        if isFileOrFolderExist(absolutePath) {
            do {
                try contents.writeToFile(absolutePath, atomically: false, encoding: NSUTF8StringEncoding)
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
    func getUTF8FileContent(fullPath: String) -> String {
        var content: String
        do {
            content = try String(contentsOfURL: NSURL(fileURLWithPath: fullPath), encoding: NSUTF8StringEncoding)
        } catch {
            return ""
        }
        return content
    }
}
