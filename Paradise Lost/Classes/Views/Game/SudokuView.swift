//
//  SudokuView.swift
//  Paradise Lost
//
//  Created by Jason Chen on 6/1/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

protocol SudokuViewDelegate {
    func startGameAction(didStartGame: Bool, usedSec: Int)
    func resetGameAction(needAlert: Bool)
    func exitGameAction(usedSec: Int)
}

class SudokuView: UIView {
    
    private var didStartGame: Bool = false
    
    private var timer: NSTimer = NSTimer()
    var seconds: Int = 0 {
        didSet {
            if seconds == 0 {
                stopTimer()
                timeNumberLabel.text = "0:0:0"
            }
        }
    }
    
    var delegate: SudokuViewDelegate? = nil
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        didStartGame = false
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        addSubview(titleLabel)
        addSubview(startButton)
        addSubview(resetButton)
        addSubview(exitButton)
        addSubview(numberLabel)
        addSubview(timeLabel)
        addSubview(timeNumberLabel)
        
        startButton.addTarget(self, action: #selector(SudokuView.startGame), forControlEvents: .TouchUpInside)
        resetButton.addTarget(self, action: #selector(SudokuView.resetGame), forControlEvents: .TouchUpInside)
        exitButton.addTarget(self, action: #selector(SudokuView.exitGame), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-40-[v0(35)]-434-[v1(30)]-8-[v2(30)]-8-[v3(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": startButton, "v2": resetButton, "v3": exitButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-509-[v2(30)]-[v0(30)]-[v1(30)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLabel, "v1": timeNumberLabel, "v2": numberLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-294-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": startButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-294-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resetButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-294-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": exitButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-294-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": numberLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-294-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-294-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": timeNumberLabel]))
    }
    
    // MARK: event response
    
    func startGame() {
        didStartGame = !didStartGame
        if didStartGame {
            startButton.setTitle(LanguageManager.getAppLanguageString("game.sudoku.startbutton.title2"), forState: .Normal)
            runTimer()
        } else {
            startButton.setTitle(LanguageManager.getAppLanguageString("game.sudoku.startbutton.title1"), forState: .Normal)
            stopTimer()
        }
        
        delegate?.startGameAction(didStartGame, usedSec: seconds)
    }
    
    func resetScreen() {
        didStartGame = false
        // timer
        stopTimer()
        showSecondText()
        // button
        startButton.setTitle(LanguageManager.getAppLanguageString("game.sudoku.startbutton.title1"), forState: .Normal)
    }
    
    func resetGame() {
        resetScreen()
        delegate?.resetGameAction(true)
    }
    
    func exitGame() {
        delegate?.exitGameAction(seconds)
    }
    
    func runTimer() {
        timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(SudokuView.addASecond), userInfo: nil, repeats: true)
    }
    
    func stopTimer() {
        timer.invalidate()
    }
    
    func showSecondText() {
        var minute: Int = seconds / 60
        let hours: Int = minute / 60
        minute = minute % 60
        let second: Int = seconds % 60
        timeNumberLabel.text = "\(hours):\(minute):\(second)"
    }
    
    func addASecond() {
        seconds = seconds + 1
        showSecondText()
    }
    
    // MARK: getters and setters
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("game.sudoku.titlelabel.text")
        label.font = UIFont.boldSystemFontOfSize(36)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var numberLabel: UILabel = {
        var label = UILabel()
        label.text = "NO. 1"
        label.font = UIFont.boldSystemFontOfSize(25)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label;
    }()
    
    func setNumber(number: Int) {
        numberLabel.text = "NO. \(number)"
    }
    
    private var timeLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("game.sudoku.timelabel.text")
        label.font = UIFont.boldSystemFontOfSize(25)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var timeNumberLabel: UILabel = {
        var label = UILabel()
        label.text = "0:0:0"
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var startButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getAppLanguageString("game.sudoku.startbutton.title1"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var resetButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getAppLanguageString("game.sudoku.resetbutton.title"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var exitButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getAppLanguageString("game.sudoku.exitbutton.title"), forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

protocol SudokuGridViewDelegate {
    func didRefreshSudoku(uSudoku: [Int])
}

class SudokuGridView: UIView {
    
    private var viewHeight: CGFloat = 0
    private var viewWidth: CGFloat = 0
    
    var delegate: SudokuGridViewDelegate? = nil
    
    var canEnable: Bool = false {
        didSet {
            selectedPoint = (0, 0)
        }
    }
    
    /// the point that user selected, (0, 0) means no selected number
    var selectedPoint: (Int, Int) = (0, 0) {
        didSet {
            setNeedsDisplay()
        }
    }
    
    /// the sudoku with only stable number
    var stableSudoku: [Int] = []
    
    /// the numbers in each grid
    var sudoku: [Int] = [] {
        didSet {
            setNeedsDisplay()
        }
    }
    
    override func drawRect(rect: CGRect) {
        let height = rect.height
        let width = rect.width
        
        let gridHeight = height / 9
        let gridWidth = width / 9
        
        let gridLine: CGFloat = 2.0
        let regionLine: CGFloat = 4.0
        
        // background
        let path = UIBezierPath(rect: rect)
        let fillColor = Color().CosmicLatte
        fillColor.setFill()
        path.fill()
        
        // line
        let gridPath = UIBezierPath()
        gridPath.lineWidth = gridLine
        let regionPath = UIBezierPath()
        regionPath.lineWidth = regionLine
        // horizontal
        for i in 0...9 {
            if i % 3 == 0 {
                regionPath.moveToPoint(CGPoint(x: 0, y: gridHeight * CGFloat(i)))
                regionPath.addLineToPoint(CGPoint(x: width, y: gridHeight * CGFloat(i)))
            } else {
                gridPath.moveToPoint(CGPoint(x: 0, y: gridHeight * CGFloat(i)))
                gridPath.addLineToPoint(CGPoint(x: width, y: gridHeight * CGFloat(i)))
            }
        }
        // vertical
        for i in 0...9 {
            if i % 3 == 0 {
                regionPath.moveToPoint(CGPoint(x: gridWidth * CGFloat(i), y: 0))
                regionPath.addLineToPoint(CGPoint(x: gridWidth * CGFloat(i), y: height))
            } else {
                gridPath.moveToPoint(CGPoint(x: gridWidth * CGFloat(i), y: 0))
                gridPath.addLineToPoint(CGPoint(x: gridWidth * CGFloat(i), y: height))
            }
        }
        UIColor.blackColor().setStroke()
        gridPath.stroke()
        regionPath.stroke()
        
        // selected field
        if canEnable {
            let (x, y) = selectedPoint
            if x != 0 && y != 0 {
                let selectedRect = UIBezierPath(rect:
                    CGRect(x: gridWidth * CGFloat(x - 1), y: gridHeight * CGFloat(y - 1), width: gridWidth, height: gridHeight))
                Color().BrightOrange.setFill()
                selectedRect.fill()
            }
        }
        
        // numbers
        for j in 0..<9 {
            for i in 0..<9 {
                if sudoku[i + j * 9] != 0 {
                    let str = "\(sudoku[i + j * 9])"
                    var attributes: [String: AnyObject] = [:]
                    if stableSudoku[i + j * 9] != 0 {
                        // stable number
                        attributes = [NSFontAttributeName: UIFont(name: "Helvetica-Bold", size: 24)!]
                    } else {
                        // number can be changed
                        if !canEnable {
                            // game pause thus do not show typed number
                            continue
                        }
                        attributes = [NSFontAttributeName: UIFont(name: "Courier", size: 22)!]
                    }
                    let centerX = gridWidth * CGFloat(i) + gridWidth / 2
                    let centerY = gridHeight * CGFloat(j) + gridHeight / 2
                    str.drawAtPoint(CGPoint(x: centerX - 8, y: centerY - 12), withAttributes: attributes)
                }
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewHeight = frame.height
        viewWidth = frame.width
        selectedPoint = (0, 0)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SudokuGridView.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: event response
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            if !canEnable {
                return
            }
            let pos = sender.locationInView(self)
            // get point
            let i = Int(9 * pos.x / viewWidth) + 1
            let j = Int(9 * pos.y / viewHeight) + 1
            selectedPoint = (i, j)
        }
    }
    
    func putNumberToPoint(number: Int) {
        let (x, y) = selectedPoint
        if x != 0 && y != 0 {
            let index = x - 1 + (y - 1) * 9
            if stableSudoku[index] == 0 {
                // not a stable number
                sudoku = SudokuManager.putNumber(sudoku, index: index, number: number)
                delegate?.didRefreshSudoku(sudoku)
            }
        }
        
    }
}

protocol SudokuPanelViewDelegate {
    func didTapNumber(number: Int)
}

/**
    3 * 4 panel to control the input, includes 0 ~ 9 number and previous, clear, next button
 */
class SudokuPanelView: UIView {
    
    private var viewHeight: CGFloat = 0
    private var viewWidth: CGFloat = 0
    
    var delegate: SudokuPanelViewDelegate? = nil
    
    override func drawRect(rect: CGRect) {
        // assume that height is 4/3 of width
        let height = rect.height
        let width = rect.width
        let plusHeight: CGFloat = 3.0
        
        // background
        let path = UIBezierPath(rect: CGRect(x: 0, y: 0, width: width, height: width))
        let fillColor = UIColor.brownColor()
        fillColor.setFill()
        path.fill()
        
        // line
        let plusPath = UIBezierPath()
        plusPath.lineWidth = plusHeight
        
        plusPath.moveToPoint(CGPoint(x: 0, y: width / 3))
        plusPath.addLineToPoint(CGPoint(x: width, y: width / 3))
        plusPath.moveToPoint(CGPoint(x: 0, y: width / 3 * 2))
        plusPath.addLineToPoint(CGPoint(x: width, y: width / 3 * 2))
        plusPath.moveToPoint(CGPoint(x: width / 3, y: 0))
        plusPath.addLineToPoint(CGPoint(x: width / 3, y: width))
        plusPath.moveToPoint(CGPoint(x: width / 3 * 2, y: 0))
        plusPath.addLineToPoint(CGPoint(x: width / 3 * 2, y: width))
        
        UIColor.whiteColor().setStroke()
        plusPath.stroke()
        
        // numbers
        for j in 0..<3 {
            for i in 0..<3 {
                let str = "\(i + j * 3 + 1)"
                    let attributes = [
                        NSFontAttributeName: UIFont.boldSystemFontOfSize(22),
                        NSForegroundColorAttributeName: UIColor.whiteColor()]
                    let centerX = width / 3 * CGFloat(i)
                    let centerY = width / 3 * CGFloat(j)
                    str.drawAtPoint(CGPoint(x: centerX + 18, y: centerY + 11), withAttributes: attributes)
            }
        }
        
        
        let buttonCenterY = (width + height) / 2
        
        // previous button
        // a triangle
        let pTriPath = UIBezierPath()
        pTriPath.moveToPoint(CGPoint(x: 0, y: buttonCenterY))
        pTriPath.addLineToPoint(CGPoint(x: width / 12, y: buttonCenterY - width / 24))
        pTriPath.addLineToPoint(CGPoint(x: width / 12, y: buttonCenterY + width / 24))
        pTriPath.addLineToPoint(CGPoint(x: 0, y: buttonCenterY))
        UIColor.greenColor().setFill()
        pTriPath.fill()
        // a rectangle
        let pRecPath = UIBezierPath(rect:
            CGRect(x: width / 12, y: buttonCenterY - width / 48, width: width / 6, height: width / 24))
        UIColor.greenColor().setFill()
        pRecPath.fill()
        
        // next button
        // a triangle
        let nTriPath = UIBezierPath()
        nTriPath.moveToPoint(CGPoint(x: width, y: buttonCenterY))
        nTriPath.addLineToPoint(CGPoint(x: width / 12 * 11, y: buttonCenterY - width / 24))
        nTriPath.addLineToPoint(CGPoint(x: width / 12 * 11, y: buttonCenterY + width / 24))
        nTriPath.addLineToPoint(CGPoint(x: width, y: buttonCenterY))
        UIColor.greenColor().setFill()
        nTriPath.fill()
        // a rectangle
        let nRecPath = UIBezierPath(rect:
            CGRect(x: width / 4 * 3, y: buttonCenterY - width / 48, width: width / 6, height: width / 24))
        UIColor.greenColor().setFill()
        nRecPath.fill()
        
        // clear
        let clearPath = UIBezierPath()
        clearPath.lineWidth = plusHeight
        clearPath.moveToPoint(CGPoint(x: width / 12 * 5, y: width / 12 * 13))
        clearPath.addLineToPoint(CGPoint(x: width / 12 * 7, y:width / 12 * 15))
        clearPath.moveToPoint(CGPoint(x: width / 12 * 7, y: width / 12 * 13))
        clearPath.addLineToPoint(CGPoint(x: width / 12 * 5, y:width / 12 * 15))
        UIColor.redColor().setStroke()
        clearPath.stroke()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        viewHeight = frame.height
        viewWidth = frame.width
        backgroundColor = UIColor.whiteColor()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SudokuGridView.handleTapGesture(_:)))
        addGestureRecognizer(tapGesture)
    }
    
    // MARK: event response
    
    func handleTapGesture(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            let pos = sender.locationInView(self)
            // judge
            let i = Int(3 * pos.x / viewWidth) + 1
            let j = Int(4 * pos.y / viewHeight)
            delegate?.didTapNumber(i + j * 3)
        }
    }
}
