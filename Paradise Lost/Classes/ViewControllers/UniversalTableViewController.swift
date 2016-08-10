//
//  UniversalTableViewController.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/12/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class UniversalTableViewController: UITableViewController, UniversalTableViewCellDelegate {
    
    /// The identifier for reused cell
    private var cellReuseIdentifier: String = "Cell"
    
    /// The name for title of navigation item
    var viewName: String = ""
    
    /// Array of item names shown on the screen
    var itemNames: [String] = []
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewName
        
        tableView.registerClass(UniversalTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCellWithIdentifier(cellReuseIdentifier, forIndexPath: indexPath) as! UniversalTableViewCell
        aCell.nameLabel.text = itemNames[indexPath.row]
        aCell.delegate = self
        return aCell
    }
    
    // MARK: UniversalTableViewDelegate
    
    /**
        Button action for control event `TouchUpInside`, should be __override__
     
        - parameter cell: Cell which has been touched
     */
    func cellButtonAction(cell: UITableViewCell) {
        fatalError("cellButtonAction(cell:) has not been implemented")
    }
}

protocol UniversalTableViewCellDelegate {
    func cellButtonAction(cell: UITableViewCell)
}

class UniversalTableViewCell: UITableViewCell {
    var delegate: UniversalTableViewCellDelegate? = nil
    
    // MARK: life cycle
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: event response
    
    func handleAction() {
        delegate?.cellButtonAction(self)
    }
    
    // MARK: private methods
    
    private func setupCell() {
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(UniversalTableViewCell.handleAction), forControlEvents: .TouchUpInside)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
            "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    // MARK: getters and setters
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "default label"
        label.font = UIFont.boldSystemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let actionButton: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle("Go", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
