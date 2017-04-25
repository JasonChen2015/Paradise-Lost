//
//  CheckJailBroken.swift
//  Paradise Lost
//
//  Created by jason on 24/2/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

class CheckJailBroken {
    static let probablePath: [String] = [
        "/Applications/Cydia.app"
        , "/Library/MobileSubstrate/MobileSubstrate.dylib"
        , "/bin/bash"
        , "/usr/sbin/sshd"
        , "/etc/apt"
        , "/private/var/lib/apt"
        //, "cydia://package/com.example.package" // openURL
    ]
    
    static let testPath: String = "/private/jailbreak.txt"
    
    class func isJailBroken() -> Bool {
        if !UIDevice.isSimulator {
            let fem = FileExplorerManager.shareInstance
            for path in probablePath {
                if fem.isFileOrFolderExist(path) {
                    return true
                }
            }
            
            if fem.createFile(testPath) {
                if fem.coverToFile(testPath, contents: "This is not a test.") {
                    let _ = fem.removeFileOrFolder(testPath)
                    return true
                }
            }
        }
        return false
    }
    
}

extension UIDevice {
    static var isSimulator: Bool {
        var isSim = false
        #if arch(i386) || arch(x86_64)
            isSim = true
        #endif
        return isSim
    }
}
