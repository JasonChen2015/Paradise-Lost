//
//  AlertManager.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/27/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

class AlertManager {
    /**
        show an alert view with one button "I see"
     */
    class func showTips(_ viewController: UIViewController,
                        message: String,
                        handler:((UIAlertAction) -> Void)?) {
        let alertCtrl = UIAlertController(title: LanguageManager.getAlertString(forKey: "tips"),
                                          message: message, preferredStyle: .alert)
        let iSeeAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "isee"),
                                       style: .default, handler: handler)
        alertCtrl.addAction(iSeeAction)
        
        viewController.present(alertCtrl, animated: true, completion: nil)
    }
    
    /**
        show an alert view with button "I see" & "continue"
     */
    class func showTipsWithContinue(_ viewController: UIViewController,
                                    message: String,
                                    handler:((UIAlertAction) -> Void)?,
                                    cHandler:((UIAlertAction) -> Void)?) {
        let alertCtrl = UIAlertController(title: LanguageManager.getAlertString(forKey: "tips"),
                                          message: message, preferredStyle: .alert)
        let iSeeAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "isee"),
                                       style: .default, handler: handler)
        let continueAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "continue"),
                                           style: .destructive, handler: cHandler)
        alertCtrl.addAction(iSeeAction)
        alertCtrl.addAction(continueAction)
        
        viewController.present(alertCtrl, animated: true, completion: nil)
    }
    
    /**
        show an action sheet with button "open", "move", "rename", "delete" and "cancel" in FileExplorer
     */
    class func showActionSheetToHandleFile(_ viewController: UIViewController,
                                           title: String,
                                           message: String,
                                           openHDL: ((UIAlertAction) -> Void)?,
                                           moveHDL: ((UIAlertAction) -> Void)?,
                                           renameDL: ((UIAlertAction) -> Void)?,
                                           deleteHDL: ((UIAlertAction) -> Void)?) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "cancel"), style: .cancel, handler: nil)
        alertCtrl.addAction(cancelAction)
        if openHDL != nil {
            let openAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "open"), style: .default, handler: openHDL)
            alertCtrl.addAction(openAction)
        }
        if moveHDL != nil {
            let moveAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "move"), style: .default, handler: moveHDL)
            alertCtrl.addAction(moveAction)
        }
        if renameDL != nil {
            let renameAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "rename"), style: .default, handler: renameDL)
            alertCtrl.addAction(renameAction)
        }
        if deleteHDL != nil {
            let deleteAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "delete"), style: .destructive, handler: deleteHDL)
            alertCtrl.addAction(deleteAction)
        }
        
        viewController.present(alertCtrl, animated: true, completion: nil)
    }
}
