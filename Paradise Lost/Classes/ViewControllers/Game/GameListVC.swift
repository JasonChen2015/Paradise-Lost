//
//  GameListVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/12/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class GameListVC: UniversalTableViewController {
    private var items = CellItemManager.itemsFromPlist("GameItems")
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        viewName = "Game List"
        itemNames = CellItemManager.nameArrayFromItems(items)
        
        super.viewDidLoad()
    }
    
    // MARK: event response
    
    override func cellButtonAction(cell: UITableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            let className = CellItemManager.classNameFromItems(items, atIndex: indexPath.row)
            if let aClass = NSClassFromString(className) {
                if aClass is UIViewController.Type {
                    let viewController = (aClass as! UIViewController.Type).init()
                    
                    if CellItemManager.needNavigationFromItems(items, atIndex: indexPath.row) {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        self.presentViewController(viewController, animated: true) { (_) in }
                    }
                }
            }
        }
    }
}
