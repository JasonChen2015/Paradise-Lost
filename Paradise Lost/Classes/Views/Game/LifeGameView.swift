//
//  LifeGameView.swift
//  Paradise Lost
//
//  Created by jason on 29/9/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

protocol LifeGameViewDelegate {
    func startGameAction(_ isGaming: Bool, speed: Double, gridSize: Int)
    func clearGameAction()
    func exitGameAction()
    func editGridAction(x: Int, y: Int)
    func addGridAction(x: Int, y: Int, index: Int)
}

class LifeGameView: UIView, UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var delegate: LifeGameViewDelegate? = nil
    let gridStyle = LifeGameManager.style
    
    fileprivate var willStart: Bool = false
    
    var chosenStyle: Int! = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
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
        
        startButton.addTarget(self, action: #selector(LifeGameView.startGame), for: .touchUpInside)
        clearButton.addTarget(self, action: #selector(LifeGameView.clearGame), for: .touchUpInside)
        exitButton.addTarget(self, action: #selector(LifeGameView.exitGame), for: .touchUpInside)
        addButton.addTarget(self, action: #selector(LifeGameView.addGrid), for: .touchUpInside)
        editButton.addTarget(self, action: #selector(LifeGameView.editGrid), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[v0(35)]-8-[v1(30)]-8-[v2(20)]-8-[v3(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": startButton, "v2": speedLabel, "v3": gridStyleText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-83-[v0(30)]-8-[v1(20)]-8-[v2(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": exitButton, "v1": speedText, "v2": gridXText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-83-[v0(30)]-8-[v1(20)]-8-[v2(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": clearButton, "v1": gridSizeLabel, "v2": gridYText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-121-[v0(20)]-8-[v1(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gridSizeText, "v1": editButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-149-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": addButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-20-[v1(==v0)]-20-[v2(==v0)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": startButton, "v1":clearButton, "v2": exitButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-46-[v0(80)]-8-[v1(50)]-46-[v2(80)]-8-[v3(50)]-46-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedLabel, "v1": speedText, "v2": gridSizeLabel, "v3": gridSizeText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0]-[v2(40)]-[v3(==v2)]-[v4(50)]-[v1(50)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": gridStyleText, "v1": editButton, "v2": gridXText, "v3": gridYText, "v4": addButton]))
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: UIPickerViewDelegate
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return gridStyle.count
    }
    
    // MARK: UIPickerViewDataSource
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        gridStyleText.text = gridStyle[row]
        chosenStyle = row
        resignAllResponder()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return gridStyle[row]
    }
    
    // MARK: event response
    
    func resignAllResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func startGame() {
        resignAllResponder()
        willStart = !willStart
        delegate?.startGameAction(willStart, speed: getDoubleFromText(speedText, num: 1.0), gridSize: getIntFromText(gridSizeText, num: 2))
        if willStart {
            startButton.setTitle(LanguageManager.getPublicString(forKey: "stop"), for: UIControlState())
        } else {
            startButton.setTitle(LanguageManager.getPublicString(forKey: "start"), for: UIControlState())
        }
    }
    
    func clearGame() {
        resignAllResponder()
        willStart = false
        startButton.setTitle(LanguageManager.getPublicString(forKey: "start"), for: UIControlState())
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
    
    fileprivate func getDoubleFromText(_ textfield: UITextField, num: Double) -> Double {
        if textfield.text != nil {
            if let number = Double(textfield.text!) {
                return number
            }
        }
        textfield.text = "\(num)"
        return num
    }
    
    fileprivate func getIntFromText(_ textfield: UITextField, num: Int) -> Int {
        if textfield.text != nil {
            if let number = Int(textfield.text!) {
                return number
            }
        }
        textfield.text = "\(num)"
        return num
    }
    
    // MARK: getters and setters
    
    fileprivate var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getGameString(forKey: "life.title.text")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var startButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getPublicString(forKey: "start"), for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var clearButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getPublicString(forKey: "clear"), for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var exitButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getPublicString(forKey: "exit"), for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var speedLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getGameString(forKey: "life.speedlabel.text")
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var speedText: UITextField = {
        var text = UITextField()
        text.text = "1"
        text.font = UIFont.systemFont(ofSize: 18)
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var gridSizeLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getGameString(forKey: "life.gridsizelabel.text")
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var gridSizeText: UITextField = {
        var text = UITextField()
        text.text = "2"
        text.font = UIFont.systemFont(ofSize: 18)
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var gridStylePicker: UIPickerView = UIPickerView()
    
    fileprivate var gridStyleText: UITextField = {
        var text = UITextField()
        text.text = LifeGameManager.LifeGameGridStyle.gliderGun.value
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var gridXText: UITextField = {
        var text = UITextField()
        text.text = "1"
        text.font = UIFont.systemFont(ofSize: 18)
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var gridYText: UITextField = {
        var text = UITextField()
        text.text = "1"
        text.font = UIFont.systemFont(ofSize: 18)
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 0.5
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var addButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getGameString(forKey: "life.addbutton.text"), for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var editButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getGameString(forKey: "life.editbutton.text"), for: UIControlState())
        button.isExclusiveTouch = true
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
    
    override func draw(_ rect: CGRect) {
        // points
        if gridArray.count == 1 { // no data then no print point
            return
        }
        for i in 0...(gridColumn - 1) {
            if i * gridSize > Int(UIScreen.main.bounds.width) { break }
            for j in 0...(gridRow - 1) {
                if j * gridSize > Int(UIScreen.main.bounds.height) { break }
                // draw rect of point
                let point = UIBezierPath(rect: CGRect(x: i * gridSize, y: j * gridSize, width: gridSize, height: gridSize))
                var color: UIColor = UIColor.white
                if gridArray[i][j] == 1 { // populate
                    color = UIColor.black
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
    
    override func draw(_ rect: CGRect) {
        // lines
        let line = UIBezierPath()
        line.lineWidth = 2.0
        for i in 0...20 {
            line.move(to: CGPoint(x: 0, y: i * 20))
            line.addLine(to: CGPoint(x: 400, y: i * 20))
            line.move(to: CGPoint(x: i * 20, y: 0))
            line.addLine(to: CGPoint(x: i * 20, y: 400))
        }
        UIColor.gray.setStroke()
        line.stroke()
        // grid
        if gridArray.count != 1 {
            UIColor.black.setFill()
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
        backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(LifeGameEditGridView.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: event response
    
    func handleTapGesture(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            let pos = sender.location(in: self)
            let x = Int(pos.x / 20)
            let y = Int(pos.y / 20)
            gridArray[x][y] = 1 - gridArray[x][y]
        }
    }
}
