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
    
    /// the dictionary of puzzles in plist
    var sudokuDict: NSDictionary = [:]
    
    // the dictionary of puzzles from user
    var userDict: [String: AnyObject] = [:]
    
    /// the total of puzzles in plist
    var totalNum: Int = 0 // 0 means no puzzle in sudokuDict
    
    /// current number of puzzle in sudokuDict
    var currentNum: Int = 1 {
        didSet { // set when loading
            if mainView != nil {
                mainView.setNumber(currentNum)
            }
        }
    }
    
    /// include the stable number of puzzle
    var stableSudoku: [Int] = [] {
        didSet { // set when loading
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
            userDict["\(currentNum)"] = str
            UserDefaultManager.setObject(userDict, forKeyEnum: .SudokuUserGrid)
            
            // check
            if SudokuManager.checkCorrect(userSudoku) {
                gameOver()
            }
        }
    }
    
    /// the time used
    var currentSecond: Int = 0 {
        didSet {
            // save to user default
            userDict["s-\(currentNum)"] = currentSecond
            UserDefaultManager.setObject(userDict, forKeyEnum: .SudokuUserGrid)
        }
    }
    
    var runGame: Bool = false {
        didSet {
            if gridView != nil {
                gridView.canEnable = runGame
            }
        }
    }
    
    var loadDataSuccess: Bool = true
    
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
        
        // load data
        loadDict()
        if let num = UserDefaultManager.objectFromKeyEnum(.SudokuNumber) {
            currentNum = num as! Int
        } else {
            currentNum = 1
            
        }
        if !loadCurrentPuzzle() {
            loadDataSuccess = false
            setAllDefault()
        }
        
        // load view
        mainView = SudokuView(frame: UIScreen.mainScreen().bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        gridView = SudokuGridView(frame: CGRect(x: 20, y: 95, width: 374, height: 374))
        gridView.delegate = self
        view.addSubview(gridView)
        
        let panel = SudokuPanelView(frame: CGRect(x: 132, y: 489, width: 150, height: 200))
        panel.delegate = self
        view.addSubview(panel)
        
        prepareGame()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if !loadDataSuccess {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.loadfailed.message"), handler: nil)
        }
        
        // do not let the screen display closed until dismiss
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    override func viewWillDisappear(animated: Bool) {
        mainView.stopTimer()
        if runGame {
            currentSecond = mainView.seconds
        }
        UIApplication.sharedApplication().idleTimerDisabled = false
        
        super.viewWillDisappear(animated)
    }
    
    func setAllDefault() {
        currentNum = 1
        let data = "530070000600195000098000060800060003400803001700020006060000280000419005000080079"
        (stableSudoku, _) = SudokuManager.getSudokuFromString(data)
        userSudoku = stableSudoku
        currentSecond = 0
    }
    
    func prepareGame() {
        mainView.seconds = currentSecond
        mainView.setNumber(currentNum)
        gridView.stableSudoku = stableSudoku
        gridView.sudoku = userSudoku
        runGame = false
        mainView.resetScreen()
    }
    
    /**
       get the sudoku and user history
     */
    func loadDict() {
        // get dictionary from plist
        guard let dictPath = NSBundle.mainBundle().pathForResource("SudokuPuzzles", ofType: "plist") else {
            return
        }
        guard let dict = NSDictionary(contentsOfFile: dictPath) else {
            return
        }
        sudokuDict = dict
        
        // get the total number of sudoku in dictionary
        guard let total = sudokuDict.objectForKey("count") else {
            sudokuDict = [:]
            totalNum = 0
            return
        }
        totalNum = total as! Int
        
        guard let udict = UserDefaultManager.objectFromKeyEnum(.SudokuUserGrid) else {
            return
        }
        userDict = udict as! [String: AnyObject]
        
        return
    }
    
    func loadCurrentPuzzle() -> Bool {
        var success = true
        
        if !sudokuDict.isEqual([:]) {
            // origin
            (stableSudoku, success) = SudokuManager.getSudokuFromDictionary(sudokuDict, atIndex: currentNum)
            // user
            if success {
                loadUserSudokuOfCurrentNum()
            }
        } else {
            success = false
        }
        return success
    }
    
    func loadUserSudokuOfCurrentNum() {
        if let str = userDict["\(currentNum)"] {
            var temp = true
            (userSudoku, temp) = SudokuManager.getSudokuFromString(str as! String)
            if !temp {
                userSudoku = stableSudoku
                currentSecond = 0
                return
            }
        } else {
            userSudoku = stableSudoku
            currentSecond = 0
            return
        }
        // get time
        if let t = userDict["s-\(currentNum)"] {
            currentSecond = t as! Int
        } else {
            currentSecond = 0
        }
    }
    
    // MARK: SudokuViewDelegate
    
    func startGameAction(didStartGame: Bool, usedSec: Int) {
        runGame = didStartGame
        if !runGame {
            // tap pause button
            currentSecond = usedSec
        }
    }
    
    func resetGameAction(needAlert: Bool) {
        if needAlert {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.reset.message"), handler: nil)
        }
        gridView.stableSudoku = stableSudoku
        gridView.sudoku = stableSudoku
        userSudoku = stableSudoku
        mainView.seconds = 0
        runGame = false
    }
    
    func exitGameAction(usedSec: Int) {
        currentSecond = usedSec
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: SudokuGridViewDelegate
    
    func didRefreshSudoku(uSudoku: [Int]) {
        userSudoku = uSudoku
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
        gridView.putNumberToPoint(number)
    }
    
    // MARK: event response
    
    func gameOver() {
        AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.gameover.message"), handler: nil)
        runGame = false
        mainView.stopTimer()
    }
    
    func clearGame() {
        if runGame {
            gridView.sudoku = stableSudoku
            userSudoku = stableSudoku
        }
    }
    
    func loadNextPuzzle() {
        if !runGame {
            if currentNum < totalNum {
                currentNum = currentNum + 1
                
                if !loadCurrentPuzzle() {
                    setAllDefault()
                }
                prepareGame()
                
                AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.runnext.message"), handler: nil)
            } else {
                AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.nonext.message"), handler: nil)
            }
        }
    }
    
    func loadPrevPuzzle() {
        if !runGame {
            if currentNum > 1 {
                currentNum = currentNum - 1
                
                if !loadCurrentPuzzle() {
                    setAllDefault()
                }
                prepareGame()
                
                AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.runprev.message"), handler: nil)
            } else {
                AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("game.sudoku.noprev.message"), handler: nil)
            }
        }
    }
}