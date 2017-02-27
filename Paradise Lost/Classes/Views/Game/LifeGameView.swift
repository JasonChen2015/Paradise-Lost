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
    func editGridAction(x x: Int, y: Int)
    func addGridAction(x x: Int, y: Int, index: Int)
}

class LifeGameView: UIView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: LifeGameViewDelegate? = nil
    let gridStyle = LifeGameManager.style
    
    private var willStart: Bool = false
    
    var chosenStyle: Int! = 0
    
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
        addSubview(gridXText)
        addSubview(gridYText)
        addSubview(addButton)
        addSubview(editButton)
        
        speedText.delegate = self
        gridSizeText.delegate = self
        gridStyleText.delegate = self
        gridXText.delegate = self
        gridYText.delegate = self
        
        // style picker
        gridStylePicker.delegate = self
        gridStylePicker.dataSource = self
        gridStyleText.inputView = gridStylePicker
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(LifeGameView.resignAllResponder))
        addGestureRecognizer(tapView)
        
        startButton.addTarget(self, action: #selector(LifeGameView.startGame), forControlEvents: .TouchUpInside)
        clearButton.addTarget(self, action: #selector(LifeGameView.clearGame), forControlEvents: .TouchUpInside)
        exitButton.addTarget(self, action: #selector(LifeGameView.exitGame), forControlEvents: .TouchUpInside)
        addButton.addTarget(self, action: #selector(LifeGameView.addGrid), forControlEvents: .TouchUpInside)
        editButton.addTarget(self, action: #selector(LifeGameView.editGrid), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[v0(35)]-8-[v1(30)]-8-[v2(20)]-8-[v3(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": startButton, "v2": speedLabel, "v3": gridStyleText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-83-[v0(30)]-8-[v1(20)]-8-[v2(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": exitButton, "v1": speedText, "v2": gridXText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-83-[v0(30)]-8-[v1(20)]-8-[v2(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": clearButton, "v1": gridSizeLabel, "v2": gridYText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-121-[v0(20)]-8-[v1(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gridSizeText, "v1": editButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-149-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": addButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0]-20-[v1(==v0)]-20-[v2(==v0)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": startButton, "v1":clearButton, "v2": exitButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-46-[v0(80)]-8-[v1(50)]-46-[v2(80)]-8-[v3(50)]-46-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedLabel, "v1": speedText, "v2": gridSizeLabel, "v3": gridSizeText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0]-[v2(40)]-[v3(==v2)]-[v4(50)]-[v1(50)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gridStyleText, "v1": editButton, "v2": gridXText, "v3": gridYText, "v4": addButton]))
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
        chosenStyle = row
        resignAllResponder()
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
        delegate?.startGameAction(willStart, speed: getDoubleFromText(speedText, num: 1.0), gridSize: getIntFromText(gridSizeText, num: 2))
        if willStart {
            startButton.setTitle(LanguageManager.getPublicString(forKey: "stop"), forState: .Normal)
        } else {
            startButton.setTitle(LanguageManager.getPublicString(forKey: "start"), forState: .Normal)
        }
    }
    
    func clearGame() {
        resignAllResponder()
        willStart = false
        startButton.setTitle(LanguageManager.getPublicString(forKey: "start"), forState: .Normal)
        delegate?.clearGameAction()
    }
    
    func exitGame() {
        clearGame()
        delegate?.exitGameAction()
    }
    
    func editGrid() {
        resignAllResponder()
        delegate?.editGridAction(x: getIntFromText(gridXText, num: 1), y: getIntFromText(gridYText, num: 1))
    }
    
    func addGrid() {
        resignAllResponder()
        delegate?.addGridAction(x: getIntFromText(gridXText, num: 1), y: getIntFromText(gridYText, num: 1), index: chosenStyle)
    }
    
    // MARK: private methods
    
    private func getDoubleFromText(textfield: UITextField, num: Double) -> Double {
        if textfield.text != nil {
            if let number = Double(textfield.text!) {
                return number
            }
        }
        textfield.text = "\(num)"
        return num
    }
    
    private func getIntFromText(textfield: UITextField, num: Int) -> Int {
        if textfield.text != nil {
            if let number = Int(textfield.text!) {
                return number
            }
        }
        textfield.text = "\(num)"
        return num
    }
    
    // MARK: getters and setters
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getGameString(forKey: "life.title.text")
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var startButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getPublicString(forKey: "start"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var clearButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getPublicString(forKey: "clear"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var exitButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getPublicString(forKey: "exit"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var speedLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getGameString(forKey: "life.speedlabel.text")
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
        label.text = LanguageManager.getGameString(forKey: "life.gridsizelabel.text")
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
        text.text = LifeGameManager.LifeGameGridStyle.GliderGun.value
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var gridXText: UITextField = {
        var text = UITextField()
        text.text = "1"
        text.font = UIFont.systemFontOfSize(18)
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var gridYText: UITextField = {
        var text = UITextField()
        text.text = "1"
        text.font = UIFont.systemFontOfSize(18)
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var addButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getGameString(forKey: "life.addbutton.text"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var editButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getGameString(forKey: "life.editbutton.text"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

class LifeGameGridView: UIView {
    var gridArray: [[Int]] = [[]] {
        didSet {
            setNeedsDisplay()
        }
    }
    var gridColumn: Int = 200
    var gridRow: Int = 200
    var gridSize: Int = 2
    
    override func drawRect(rect: CGRect) {
        // points
        if gridArray.count == 1 { // no data then no print point
            return
        }
        for i in 0...(gridColumn - 1) {
            if i * gridSize > Int(UIScreen.mainScreen().bounds.width) { break }
            for j in 0...(gridRow - 1) {
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

// assume this view is 400 * 400
class LifeGameEditGridView: UIView {
    var gridArray: [[Int]] = [[]] {
        didSet {
            setNeedsDisplay()
        }
    }
    var gridWidth: Int = 20
    var gridHeight: Int = 20
    var gridSize: Int = 2
    
    override func drawRect(rect: CGRect) {
        // lines
        let line = UIBezierPath()
        line.lineWidth = 2.0
        for i in 0...20 {
            line.moveToPoint(CGPoint(x: 0, y: i * 20))
            line.addLineToPoint(CGPoint(x: 400, y: i * 20))
            line.moveToPoint(CGPoint(x: i * 20, y: 0))
            line.addLineToPoint(CGPoint(x: i * 20, y: 400))
        }
        UIColor.grayColor().setStroke()
        line.stroke()
        // grid
        if gridArray.count != 1 {
            UIColor.blackColor().setFill()
            for i in 0...19 {
                for j in 0...19 {
                    if gridArray[i][j] == 1 {
                        let blacks = UIBezierPath(rect: CGRect(x: i * 20, y: j * 20, width: 20, height: 20))
                        blacks.fill()
                    }
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LifeGameEditGridView.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: event response
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let pos = sender.locationInView(self)
            let x = Int(pos.x / 20)
            let y = Int(pos.y / 20)
            gridArray[x][y] = 1 - gridArray[x][y]
        }
    }
}
