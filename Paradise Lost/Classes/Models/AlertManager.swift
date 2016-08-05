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
    class func showTips(viewController: UIViewController,
                        message: String,
                        handler:(UIAlertAction -> Void)?) {
        let alertCtrl = UIAlertController(title: LanguageManager.getAppLanguageString("alert.tips.title"),
                                          message: message, preferredStyle: .Alert)
        let iSeeAction = UIAlertAction(title: LanguageManager.getAppLanguageString("alert.isee.title"),
                                       style: .Default, handler: handler)
        alertCtrl.addAction(iSeeAction)
        
        viewController.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    /**
        show an alert view with button "I see" & "continue"
     */
    class func showTipsWithContinue(viewController: UIViewController,
                                    message: String,
                                    handler:(UIAlertAction -> Void)?,
                                    cHandler:(UIAlertAction -> Void)?) {
        let alertCtrl = UIAlertController(title: LanguageManager.getAppLanguageString("alert.tips.title"),
                                          message: message, preferredStyle: .Alert)
        let iSeeAction = UIAlertAction(title: LanguageManager.getAppLanguageString("alert.isee.title"),
                                       style: .Default, handler: handler)
        let continueAction = UIAlertAction(title: LanguageManager.getAppLanguageString("alert.continue.title"),
                                           style: .Destructive, handler: cHandler)
        alertCtrl.addAction(iSeeAction)
        alertCtrl.addAction(continueAction)
        
        viewController.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    /**
        show an action sheet with button "open", "move", "delete" and "cancel" in FileExplorer
     */
    class func showActionSheetToHandleFile(viewController: UIViewController,
                                           title: String,
                                           message: String,
                                           openHDL: ((UIAlertAction) -> Void)?,
                                           moveHDL: ((UIAlertAction) -> Void)?,
                                           deleteHDL: ((UIAlertAction) -> Void)?) {
        let alertCtrl = UIAlertController(title: title, message: message, preferredStyle: .ActionSheet)
        let openAction = UIAlertAction(title: "Open", style: .Default, handler: openHDL)
        let moveAction = UIAlertAction(title: "Move", style: .Default, handler: moveHDL)
        let deleteAction = UIAlertAction(title: "Delete", style: .Destructive, handler: deleteHDL)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        alertCtrl.addAction(cancelAction)
        if openHDL != nil {
            alertCtrl.addAction(openAction)
        }
        alertCtrl.addAction(moveAction)
        alertCtrl.addAction(deleteAction)
        
        viewController.presentViewController(alertCtrl, animated: true, completion: nil)
    }
}
