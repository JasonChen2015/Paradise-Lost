//
//  TwoZeroFourEightView.swift
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

class TwoZeroFourEightView: UIView {
    
    /// the length of a tile
    private let length = 86
    
    /// distance between two tile
    private let padding = 6
    
    /// restore the (dimension * dimension) of tile
    private var tilesSet: [UIView] = []
    
    var delegate: TwoZeroFourEightViewDelegate? = nil
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color().CosmicLatte
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        // add tiles
        for j in 0..<4 {
            for i in 0..<4 {
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
        
        newButton.addTarget(self, action: #selector(TwoZeroFourEightView.newGame), forControlEvents: .TouchUpInside)
        exitButton.addTarget(self, action: #selector(TwoZeroFourEightView.exitGame), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-54-[v0(60)]-[v1(30)]-[v2(374)]-[v3(30)]-[v4(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": scoreTextLabel, "v2": tilesBackground, "v3": highScoreTextLabel, "v4": highScoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:[v0(30)]-[v1]-[v2(30)]-[v3(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scoreNumLabel, "v1": tilesBackground, "v2": newButton, "v3": exitButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": scoreTextLabel, "v1": scoreNumLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(374)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": tilesBackground]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": highScoreTextLabel, "v1": newButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]-[v1(100)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": highScoreNumLabel, "v1": exitButton]))
    }
    
    // MARK: event response
    
    func newGame() {
        delegate?.newButtonAction()
    }
    
    func exitGame() {
        delegate?.exitButtonAction()
    }
    
    // MARK: getters and setters
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("game.2048.titlelabel.text")
        label.textColor = Color().Kokiake
        label.font = UIFont.boldSystemFontOfSize(54)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var scoreTextLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("game.2048.scoretextlabel.text")
        label.textColor = Color().Kurotobi
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var scoreNumLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = Color().Kakitsubata
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var tilesBackground: UIView = {
        var view = UIView()
        view.backgroundColor = Color().TileBackground
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var highScoreTextLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("game.2048.highscoretextlabel.text")
        label.textColor = Color().Kurotobi
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var highScoreNumLabel: UILabel = {
        var label = UILabel()
        label.text = "0"
        label.textColor = Color().Kakitsubata
        label.font = UIFont.boldSystemFontOfSize(27)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var newButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitleColor(Color().Kurotobi, forState: .Normal)
        button.setTitle(LanguageManager.getAppLanguageString("game.2048.newbutton.title"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var exitButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitleColor(Color().Kurotobi, forState: .Normal)
        button.setTitle(LanguageManager.getAppLanguageString("game.2048.exitbutton.title"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    func setValueOfTile(index: Int, value: Int) {
        let tile = tilesSet[index] as! TZFETileView
        tile.value = value
    }
    
    func setValueOfScore(value: Int) {
        scoreNumLabel.text = "\(value)"
    }
    
    func setValueOfHighScore(value: Int) {
        highScoreNumLabel.text = "\(value)"
    }
}

class TZFETileView: UIView {

    private let colorMap = [
        0: Color().mixColorBetween(Color().TileColor, colorB: Color().TileBackground),
        2: Color().mixColorBetween(Color().TileColor, weightA: 1, colorB: Color().TileGoldColor, weightB: 0),
        4: Color().mixColorBetween(Color().TileColor, weightA: 0.9, colorB: Color().TileGoldColor, weightB: 0.1),
        8: Color().mixColorBetween(Color().BrightOrange, weightA: 0.55, colorB: Color().TileColor, weightB: 0.45),
        16: Color().mixColorBetween(Color().BrightRed, weightA: 0.55, colorB: Color().TileColor, weightB: 0.45),
        32: Color().mixColorBetween(Color().VividRed, weightA: 0.55, colorB: Color().TileColor, weightB: 0.45),
        64: Color().mixColorBetween(Color().PureRed, weightA: 0.55, colorB: Color().TileColor, weightB: 0.45),
        128: Color().mixColorBetween(Color().TileColor, weightA: 0.7, colorB: Color().TileGoldColor, weightB: 0.3),
        256: Color().mixColorBetween(Color().TileColor, weightA: 0.6, colorB: Color().TileGoldColor, weightB: 0.4),
        512: Color().mixColorBetween(Color().TileColor, weightA: 0.5, colorB: Color().TileGoldColor, weightB: 0.5),
        1024: Color().mixColorBetween(Color().TileColor, weightA: 0.4, colorB: Color().TileGoldColor, weightB: 0.6),
        2048: Color().mixColorBetween(Color().TileColor, weightA: 0.3, colorB: Color().TileGoldColor, weightB: 0.7)
    ]
    
    var value: Int = 0 {
        didSet {
            if value > 2048 {
                backgroundColor = UIColor.blackColor()
            } else {
                backgroundColor = colorMap[value]
            }
            if value == 0 {
                contentLabel.text = ""
            } else {
                contentLabel.text = "\(value)"
                show()
            }
            if value == 2 || value == 4 {
                contentLabel.textColor = Color().DarkGrayishOrange
            } else {
                contentLabel.textColor = Color().LightGrayishOrange
            }
        }
    }
    
    lazy var contentLabel: UILabel = {
        var label = UILabel()
        label.textColor = UIColor.whiteColor()
        label.font = UIFont.boldSystemFontOfSize(27) // originContentFont
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    init(frame: CGRect, value: Int) {
        super.init(frame: frame)
        
        self.value = value
        backgroundColor = colorMap[self.value]
        self.contentLabel.text = (value == 0) ? "" : "\(self.value)"
        
        addSubview(contentLabel)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": self.contentLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": self.contentLabel]))
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: private methods
    
    private func show() {
        UIView.animateWithDuration(0.1, animations: { () -> Void in
            self.transform = CGAffineTransformMakeScale(1.1, 1.1)
            }) { (finished: Bool) -> Void in
                UIView.animateWithDuration(0.05, animations: { () -> Void in
                    self.transform = CGAffineTransformIdentity
                })
        }
    }
}
