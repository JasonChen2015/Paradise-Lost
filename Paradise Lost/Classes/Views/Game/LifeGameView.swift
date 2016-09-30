//
//  LifeGameView.swift
//  Paradise Lost
//
//  Created by jason on 29/9/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

protocol LifeGameViewDelegate {
    func startGameAction(isGaming: Bool, speed: Double, gridSize: Int)
    func clearGameAction()
    func exitGameAction()
    func chooseGridStyle(index: Int)
}

class LifeGameView: UIView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: LifeGameViewDelegate? = nil
    let gridStyle = LifeGameManager.style
    
    private var willStart: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(startButton)
        addSubview(clearButton)
        addSubview(exitButton)
        addSubview(speedLabel)
        addSubview(speedText)
        addSubview(gridSizeLabel)
        addSubview(gridSizeText)
        addSubview(gridStyleText)
        
        speedText.delegate = self
        gridSizeText.delegate = self
        gridStyleText.delegate = self
        
        // style picker
        gridStylePicker.delegate = self
        gridStylePicker.dataSource = self
        gridStyleText.inputView = gridStylePicker
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(LifeGameView.resignAllResponder))
        addGestureRecognizer(tapView)
        
        startButton.addTarget(self, action: #selector(LifeGameView.startGame), forControlEvents: .TouchUpInside)
        clearButton.addTarget(self, action: #selector(LifeGameView.clearGame), forControlEvents: .TouchUpInside)
        exitButton.addTarget(self, action: #selector(LifeGameView.exitGame), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[v0(35)]-8-[v1(30)]-8-[v2(20)]-8-[v3(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": startButton, "v2": speedLabel, "v3": gridStyleText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-83-[v0(30)]-8-[v1(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": exitButton, "v1": speedText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-83-[v0(30)]-8-[v1(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": clearButton, "v1": gridSizeLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-121-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gridSizeText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0]-20-[v1(==v0)]-20-[v2(==v0)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": startButton, "v1":clearButton, "v2": exitButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-46-[v0(80)]-8-[v1(50)]-46-[v2(80)]-8-[v3(50)]-46-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedLabel, "v1": speedText, "v2": gridSizeLabel, "v3": gridSizeText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gridStyleText]))
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: UIPickerViewDelegate
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gridStyle.count
    }
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gridStyleText.text = gridStyle[row]
        resignAllResponder()
        if !willStart {
            delegate?.chooseGridStyle(row)
        }
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gridStyle[row]
    }
    
    // MARK: event response
    
    func resignAllResponder() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }
    
    func startGame() {
        resignAllResponder()
        willStart = !willStart
        delegate?.startGameAction(willStart, speed: getSpeedText(), gridSize: getGridSizeText())
        if willStart {
            startButton.setTitle("Stop", forState: .Normal)
        } else {
            startButton.setTitle("Start", forState: .Normal)
        }
    }
    
    func clearGame() {
        resignAllResponder()
        willStart = false
        startButton.setTitle("Start", forState: .Normal)
        delegate?.clearGameAction()
    }
    
    func exitGame() {
        clearGame()
        delegate?.exitGameAction()
    }
    
    // MARK: private methods
    
    func getSpeedText() -> Double {
        if speedText.text != nil {
            if let speed = Double(speedText.text!) {
                return speed
            }
        }
        speedText.text = "1"
        return 1.0
    }
    
    func getGridSizeText() -> Int {
        if gridSizeText.text != nil {
            if let gridSize = Int(gridSizeText.text!) {
                return gridSize
            }
        }
        gridSizeText.text = "2"
        return 2
    }
    
    // MARK: getters and setters
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("game.life.title.text")
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var startButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("Start", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var clearButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("Clear", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var exitButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("Exit", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var speedLabel: UILabel = {
        var label = UILabel()
        label.text = "Speed(s): "
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var speedText: UITextField = {
        var text = UITextField()
        text.text = "1"
        text.font = UIFont.systemFontOfSize(18)
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var gridSizeLabel: UILabel = {
        var label = UILabel()
        label.text = "Grid Size: "
        label.textAlignment = .Right
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var gridSizeText: UITextField = {
        var text = UITextField()
        text.text = "2"
        text.font = UIFont.systemFontOfSize(18)
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var gridStylePicker: UIPickerView = UIPickerView()
    
    private var gridStyleText: UITextField = {
        var text = UITextField()
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
}

class LifeGameGridView: UIView {
    var gridArray: [[Int]] = [[]] {
        didSet {
            setNeedsDisplay()
        }
    }
    var gridWidth: Int = 200
    var gridHeight: Int = 200
    var gridSize: Int = 2
    
    override func drawRect(rect: CGRect) {
        // points
        if gridArray.count == 1 { // no data then no print point
            return
        }
        for i in 0...Int(gridWidth) {
            if i * gridSize > Int(UIScreen.mainScreen().bounds.width) { break }
            for j in 0...Int(gridHeight) {
                if j * gridSize > Int(UIScreen.mainScreen().bounds.height) { break }
                // draw rect of point
                let point = UIBezierPath(rect: CGRect(x: i * gridSize, y: j * gridSize, width: gridSize, height: gridSize))
                var color: UIColor = UIColor.whiteColor()
                if gridArray[i][j] == 1 { // populate
                    color = UIColor.blackColor()
                }
                color.setFill()
                point.fill()
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
