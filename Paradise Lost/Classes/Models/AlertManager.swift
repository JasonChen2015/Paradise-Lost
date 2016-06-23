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
    class func showTips(viewController: UIViewController, message: String, handler:(UIAlertAction -> Void)?) {
        let alertCtrl = UIAlertController(title: LanguageManager.getAppLanguageString("alert.tips.title"), message: message, preferredStyle: .Alert)
        let iSeeAction = UIAlertAction(title: LanguageManager.getAppLanguageString("alert.isee.title"), style: .Default, handler: handler)
        alertCtrl.addAction(iSeeAction)
        
        viewController.presentViewController(alertCtrl, animated: true, completion: nil)
    }
}
