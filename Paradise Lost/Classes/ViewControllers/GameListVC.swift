//
//  GameListVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/12/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

class GameListVC: UniversalTableViewController {

    // MARK: life cycle

    override func viewDidLoad() {
        viewName = "Game List"
        loadItem("GameItems")

        super.viewDidLoad()
    }

    // MARK: event response

    override func cellButtonAction(cell: UITableViewCell) {
        // TODO:
        if let indexPath = tableView.indexPathForCell(cell) {
            print("\(indexPath.row)")
        }
    }
}
