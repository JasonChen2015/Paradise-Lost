//
//  TwoZeroFourEightV.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/16/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

protocol TwoZeroFourEightViewDelegate {
    func newButtonAction()
    func exitButtonAction()
}

class TwoZeroFourEightV: UIView {
    
    /// dimension of tiles
    let dimension = 4
    /// the length of a tile
    let length = 86
    /// distance between two tile
    let padding = 6
    
    /// restore the (dimension * dimension) of tile
    var tilesSet: [UIView] = []
    
    var delegate: TwoZeroFourEightViewDelegate? = nil
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: event response
    
    func newGame() {
        delegate?.newButtonAction()
    }
    
    func exitGame() {
        delegate?.exitButtonAction()
    }
    
    func moveAside(index: Int, atDirecttion direct: TileItemManager.Direction) {
        switch direct {
        case .None:
            break;
        case .Up:
            break
        case .Down:
            break
        case .Left:
            break
        case .Right:
            break
        }
    }
    
    // MARK: private methods
    
    func setupView() {
        // add tiles
        for j in 0..<dimension {
            for i in 0..<dimension {
                let tile = TZFETileView(
                    frame: CGRect(
                        x: (padding + i * (length + padding)),
                        y: (padding + j * (length + padding)),
                        width: length,
                        height: length
                    ),
                    value: 0
                )
                tilesBackground.addSubview(tile)
                tilesSet.append(tile)
            }
        }
        
        addSubview(titleLabel)
        addSubview(scoreTextLabel)
        addSubview(scoreNumLabel)
        addSubview(tilesBackground)
        addSubview(highScoreTextLabel)
        addSubview(highScoreNumLabel)
        addSubview(newButton)
        addSubview(exitButton)
        
        newButton.addTarget(self, action: "newGame", forControlEvents: .TouchUpInside)
        exitButton.addTarget(self, action: "exitGame", forControlEvents: .TouchUpInside)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-54-[v0(60)]-[v1(30)]-[v2(374)]-[v3(30)]-[v4(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": scoreTextLabel, "v2": tilesBackground, "v3": highScoreTextLabel, "v4": highScoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v0(30)]-[v1]-[v2(30)]-[v3(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scoreNumLabel, "v1": tilesBackground, "v2": newButton, "v3": exitButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scoreTextLabel, "v1": scoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(374)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tilesBackground]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": highScoreTextLabel, "v1": newButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": highScoreNumLabel, "v1": exitButton]))
    }
    
    // MARK: getters and setters
    
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
    
    var tilesBackground: UIView = {
        var view = UIView()
        view.backgroundColor = Color().FrechBeige
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
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
    
    var newButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("New Game", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    var exitButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("Exit", forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    /*
    00 01 02 03
    04 05 06 07
    08 09 10 11
    12 13 14 15
    */
    
    /**
     parameter x: 0..<dimension * dimension
     parameter y: 0..<dimension * dimension
     */
    func setValueOfTile(x x: Int, y: Int, value: Int) {
        setValueOfTile((x + (y - 1) * dimension), value: value)
    }
    
    func setValueOfTile(index: Int, value: Int) {
        (tilesSet[index] as! TZFETileView).value = value
    }
}

class TZFETileView: UIView {
    private let colorMap = [
        0: Color().CosmicLatte,
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
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(frame: CGRect, value: Int) {
        super.init(frame: frame)
        self.value = value
        backgroundColor = colorMap[self.value]
        contentLabel.text = "\(self.value)"
        
        addSubview(contentLabel)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: event response
    
    func show(index: Int) {
        
    }
    
    func disappear(index: Int) {
        
    }
}
