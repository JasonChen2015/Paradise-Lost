//
//  ToolListVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/12/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class ToolListVC: UniversalTableViewController {
    fileprivate var items = TableCellItemManager.itemsFromPlist("ToolItems", ofType: .tool)
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        viewName = LanguageManager.getToolString(forKey: "viewname")
        itemNames = TableCellItemManager.nameArrayFromItems(items)
        
        super.viewDidLoad()
    }
    
    // MARK: event response
    
    override func cellButtonAction(_ cell: UITableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            let className = TableCellItemManager.classNameFromItems(items, atIndex: indexPath.row)
            if let aClass = NSClassFromString(className) {
                if aClass is UIViewController.Type {
                    let viewController = (aClass as! UIViewController.Type).init()
                    
                    if TableCellItemManager.needNavigationFromItems(items, atIndex: indexPath.row) {
                        self.navigationController?.pushViewController(viewController, animated: true)
                    } else {
                        self.present(viewController, animated: false)
                    }
                }
            }
        }
    }
}
