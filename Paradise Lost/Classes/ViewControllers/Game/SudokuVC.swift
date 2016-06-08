//
//  SudokuVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 6/1/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class SudokuVC: UIViewController, SudokuViewDelegate, SudokuGridViewDelegate, SudokuPanelViewDelegate {
    
    var mainView: SudokuView!
    var gridView: SudokuGridView!
    
    var sudokuDict: NSDictionary?
    var totalNum: Int = 0
    var currentNum: Int = 0 {
        didSet {
            if mainView != nil {
                mainView.setNumber(currentNum)
            }
        }
    }
    
    /// include the stable number
    var stableSudoku: [Int] = [] {
        didSet {
            if gridView != nil {
                gridView.stableSudoku = stableSudoku
            }
        }
    }
    
    /// the state shown on user interface
    var userSudoku: [Int] = [] {
        didSet {
            // save to user default
            let str = SudokuManager.getStringFromSudoku(userSudoku)
            UserDefaultManager.setValue(str, forKeyEnum: .SudokuUserGrid)
            
            // show on UI
            if gridView != nil {
                gridView.sudoku = userSudoku
                if SudokuManager.checkCorrect(userSudoku) {
                    gameOver()
                }
            }
        }
    }
    
    var selectedPoint: (Int, Int) = (0, 0) {
        didSet {
            if gridView != nil {
                gridView.selectedPoint = selectedPoint
            }
        }
    }
    
    /// the time used
    var currentSecond: Int = 0 {
        didSet {
            // save to user default
            UserDefaultManager.setValue(currentSecond, forKeyEnum: .SudokuTime)
        }
    }
    
    var runGame: Bool = false {
        didSet {
            if gridView != nil {
                gridView.canEnable = runGame
            }
        }
    }
    
    // MARK: life cycle
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init Data
        loadData()
        
        // load view
        mainView = SudokuView(frame: UIScreen.mainScreen().bounds)
        mainView.delegate = self
        mainView.seconds = currentSecond
        view.addSubview(mainView)
        
        gridView = SudokuGridView(frame: CGRect(x: 20, y: 95, width: 374, height: 374))
        gridView.delegate = self
        gridView.stableSudoku = stableSudoku
        gridView.sudoku = userSudoku
        view.addSubview(gridView)
        
        let panel = SudokuPanelView(frame: CGRect(x: 132, y: 489, width: 150, height: 200))
        panel.delegate = self
        view.addSubview(panel)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // do not let the screen display closed until dismiss
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    func loadData() {
        if let dictPath = NSBundle.mainBundle().pathForResource("SudokuPuzzles", ofType: "plist") {
            sudokuDict = NSDictionary(contentsOfFile: dictPath)
            // get the total number of sudoku in dictionary
            if let total = sudokuDict?.objectForKey("count") {
                totalNum = total as! Int
            } else {
                totalNum = 0
            }
            // get the current number of puzzle
            if let num = UserDefaultManager.valueFromKeyEnum(.SudokuNumber) {
                currentNum = num as! Int
            } else {
                currentNum = 1
            }
            // get the stable sudoku
            if let str = sudokuDict?.objectForKey("\(currentNum)") {
                stableSudoku = SudokuManager.getSudokuFromString(str as! String)
            } else {
                AlertManager.showTips(self, message: "Can not load data", handler: nil)
                stableSudoku = SudokuManager.getSudokuFromString("")
            }
            // get the user sudoku
            if let ustr = UserDefaultManager.valueFromKeyEnum(.SudokuUserGrid) {
                userSudoku = SudokuManager.getSudokuFromString(ustr as! String)
                // get time
                if let t = UserDefaultManager.valueFromKeyEnum(.SudokuTime) {
                    currentSecond = t as! Int
                } else {
                    currentSecond = 0
                }
            } else {
                // can not load user sudoku then reset it
                userSudoku = stableSudoku
                currentSecond = 0
            }
        } else {
            AlertManager.showTips(self, message: "Can not load puzzles", handler: nil)
            let data = "530070000600195000098000060800060003400803001700020006060000280000419005000080079"
            stableSudoku = SudokuManager.getSudokuFromString(data)
            userSudoku = stableSudoku
        }
    }
    
    // MARK: SudokuViewDelegate
    
    func startGameAction(didStartGame: Bool) {
        runGame = didStartGame
    }
    
    func resetGameAction(needAlert: Bool) {
        if needAlert {
            AlertManager.showTips(self, message: "Reset the game!", handler: nil)
        }
        userSudoku = stableSudoku
        selectedPoint = (0, 0)
        currentSecond = 0
        runGame = false
    }
    
    func exitGameAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func refreshTimer(seconds: Int) {
        currentSecond = seconds
    }
    
    // MARK: SudokuGridViewDelegate
    
    func didTapPoint(x x: Int, y: Int) {
        selectedPoint = (x, y)
    }
    
    // MARK: SudokuPanelViewDelegate
    
    func didTapNumber(number: Int) {
        if number > 9 {
            switch number {
            case 10:
                loadPrevPuzzle()
                return
            case 11:
                clearGame()
                return
            case 12:
                loadNextPuzzle()
                return
            default:
                return
            }
        }
        if !runGame {
            return
        }
        let (x, y) = selectedPoint
        if x != 0 && y != 0 {
            let index = x - 1 + (y - 1) * 9
            if stableSudoku[index] == 0 {
                // not a stable number
                userSudoku = SudokuManager.putNumber(userSudoku, index: index, number: number)
            }
        }
    }
    
    // MARK: event response
    
    func gameOver() {
        AlertManager.showTips(self, message: "You finished the Sudoku.", handler: nil)
        runGame = false
    }
    
    func clearGame() {
        if runGame {
            userSudoku = stableSudoku
            selectedPoint = (0, 0)
        }
    }
    
    func loadNextPuzzle() {
        if !runGame {
            if currentNum < totalNum {
                currentNum = currentNum + 1
                
                stableSudoku = SudokuManager.getSudokuFromDictionary(sudokuDict!, atIndex: currentNum)
                resetGameAction(false)
                mainView.resetScreen()
                
                AlertManager.showTips(self, message: "You will run the next puzzle", handler: nil)
            } else {
                AlertManager.showTips(self, message: "It's the last puzzle!", handler: nil)
            }
        }
    }
    
    func loadPrevPuzzle() {
        if !runGame {
            if currentNum > 1 {
                currentNum = currentNum - 1
                
                stableSudoku = SudokuManager.getSudokuFromDictionary(sudokuDict!, atIndex: currentNum)
                resetGameAction(false)
                mainView.resetScreen()
                
                AlertManager.showTips(self, message: "You will run the previous puzzle", handler: nil)
            } else {
                AlertManager.showTips(self, message: "It's the first puzzle!", handler: nil)
            }
        }
    }
}