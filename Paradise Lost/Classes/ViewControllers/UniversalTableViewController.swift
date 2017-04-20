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
    fileprivate var cellReuseIdentifier: String = "Cell"
    
    /// The name for title of navigation item
    var viewName: String = ""
    
    /// Array of item names shown on the screen
    var itemNames: [String] = []
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = viewName
        
        tableView.register(UniversalTableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let aCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as! UniversalTableViewCell
        aCell.nameLabel.text = itemNames[indexPath.row]
        aCell.delegate = self
        return aCell
    }
    
    // MARK: UniversalTableViewDelegate
    
    /**
        Button action for control event `TouchUpInside`, should be __override__
     
        - parameter cell: Cell which has been touched
     */
    func cellButtonAction(_ cell: UITableViewCell) {
        fatalError("cellButtonAction(cell:) has not been implemented")
    }
}

protocol UniversalTableViewCellDelegate {
    func cellButtonAction(_ cell: UITableViewCell)
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
    
    fileprivate func setupCell() {
        addSubview(nameLabel)
        addSubview(actionButton)
        
        actionButton.addTarget(self, action: #selector(UniversalTableViewCell.handleAction), for: .touchUpInside)
        
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "H:|-16-[v0]-8-[v1(80)]-8-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": actionButton]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": actionButton]))
    }
    
    // MARK: getters and setters
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "default label"
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Go", for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
