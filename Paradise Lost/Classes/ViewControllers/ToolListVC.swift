//
//  ToolListVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/12/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

class ToolListVC: UniversalTableViewController {

    // MARK: life cycle

    override func viewDidLoad() {
        viewName = "Tool List"
        loadItem("ToolItems")
        
        super.viewDidLoad()
    }

    // MARK: event response

    override func cellButtonAction(cell: UITableViewCell) {
        if let indexPath = tableView.indexPathForCell(cell) {
            // TODO:
            print("\(indexPath.row)")
        }
    }
}
