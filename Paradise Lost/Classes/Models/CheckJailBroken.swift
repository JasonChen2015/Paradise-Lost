//
//  CheckJailBroken.swift
//  Paradise Lost
//
//  Created by jason on 24/2/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import Foundation

class CheckJailBroken {
    let probablePath: [String] = [
        "/Applications/Cydia.app"
        , "/Library/MobileSubstrate/MobileSubstrate.dylib"
        , "/bin/bash"
        , "/usr/sbin/sshd"
        , "/etc/apt"
        , "/private/var/lib/apt"
        //, "cydia://package/com.example.package" // openURL
    ]
    
    let testPath: String = "/private/jailbreak.txt"
    
    class func isJailBroken() -> Bool {
        #if !(TARGET_IPHONE_SIMULATOR)
            var fem = FileExplorerManager()
            for path in probablePath {
                if fem.isFileOrFolderExist(path) {
                    return true
                }
            }
            
            if fem.createFile(testPath) {
                if fem.coverToFile(testPath, contents: "This is not a test.") {
                    fem.removeFileOrFolder(testPath)
                    return true
                }
            }
        #endif
        return false
    }
    
}