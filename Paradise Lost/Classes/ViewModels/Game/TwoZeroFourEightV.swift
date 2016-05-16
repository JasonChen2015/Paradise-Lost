//
//  TwoZeroFourEightV.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/16/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

class TwoZeroFourEightV: UIView {
    
    /// dimension of tiles
    let dimension = 4
    /// the length of a tile
    let length = 86
    /// distance between two tile
    let padding = 6
    
    var titleLabel: UILabel = {
        var label = UILabel()
        label.text = "2048"
        label.font = UIFont.boldSystemFontOfSize(54)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var scoreTextLabel: UILabel = {
        var label = UILabel()
        label.text = "Score:"
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var scoreNumLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var highScoreTextLabel: UILabel = {
       var label = UILabel()
        label.text = "High Score:"
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var highScoreNumLabel: UILabel = {
        var label = UILabel()
        // TODO: read from local data
        label.text = "0"
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        // TODO: add main playground and button for new game or exit
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setupView() {
        addSubview(titleLabel)
        addSubview(scoreTextLabel)
        addSubview(scoreNumLabel)
        addSubview(highScoreTextLabel)
        addSubview(highScoreNumLabel)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-38-[v0(60)]-16-[v1(30)]-374-[v2(60)]-8-[v3(60)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": scoreTextLabel, "v2": highScoreTextLabel, "v3": highScoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-114-[v0(30)]-592-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scoreTextLabel, "v1": scoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": highScoreTextLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": highScoreNumLabel]))
    }
}

class TZFEBoxView: UIView {
    private let colorMap = [
        0: UIColor.whiteColor(),
        2: UIColor.redColor(),
        4: UIColor.orangeColor(),
        8: UIColor.yellowColor(),
        16: UIColor.greenColor(),
        32: UIColor.brownColor(),
        64: UIColor.blueColor(),
        128: UIColor.purpleColor(),
        256: UIColor.cyanColor(),
        512: UIColor.lightGrayColor(),
        1024: UIColor.magentaColor(),
        2048: UIColor.blackColor()
    ]
    
    var value: Int = 0 {
        didSet {
            backgroundColor = colorMap[value]
            contentLabel.text = "\(value)"
        }
    }
    
    var contentLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.systemFontOfSize(20)
        label.textAlignment = .Center
        return label
    }()
    
    init(frame: CGRect, value: Int) {
        // TODO:
        super.init(frame: frame)
        self.value = value
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
