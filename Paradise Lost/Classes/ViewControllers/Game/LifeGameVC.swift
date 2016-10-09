//
//  LifeGameVC.swift
//  Paradise Lost
//
//  Created by jason on 29/9/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class LifeGameVC: UIViewController, LifeGameViewDelegate {
    
    var mainView: LifeGameView!
    var gridView: LifeGameGridView!
    var editGridView: LifeGameEditGridView!
    var manager: LifeGameManager!
    
    var editX: Int! = 0
    var editY: Int! = 0
    
    var timer: NSTimer = NSTimer()
    
    // MARK: life cycle
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
        
        // initial data
        
        manager = LifeGameManager()
        manager.row = 200
        manager.column = 200
        // initial patterns
        manager.addGliderGunAtPoint(x: 20, y: 20)
        
        // view
        
        mainView = LifeGameView(frame: UIScreen.mainScreen().bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        gridView = LifeGameGridView(frame: CGRect(x: 7, y: 200, width: 400, height: 400))
        gridView.gridArray = manager.getStatus()
        gridView.gridColumn = manager.row
        gridView.gridRow = manager.column
        gridView.gridSize = 2
        view.addSubview(gridView)
        
        editGridView = LifeGameEditGridView(frame: CGRect(x: 7, y: 168, width: 400, height: 400))
        editGridView.hidden = true
        view.addSubview(editGridView)
    }
    
    // MARK: LifeGameViewDelegate
    
    func startGameAction(isGaming: Bool, speed: Double, gridSize: Int) {
        if isGaming {
            gridView.gridSize = gridSize
            timer = NSTimer.scheduledTimerWithTimeInterval(speed, target: self, selector: #selector(LifeGameVC.generateNextStatus), userInfo: nil, repeats: true)
        } else {
            timer.invalidate()
        }
    }
    
    func clearGameAction() {
        if timer.valid {
            timer.invalidate()
        }
        manager.clearStatus()
        gridView.gridArray = manager.getStatus()
    }
    
    func exitGameAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func editGridAction(x x: Int, y: Int) {
        editGridView.hidden = !editGridView.hidden
        if !editGridView.hidden {
            editX = x
            editY = y
            editGridView.gridArray = manager.getEditable(x, y: y, rows: 20, columns: 20)
        } else {
            manager.setEditable(editX, y: editY, rows: 20, columns: 20, array: editGridView.gridArray)
            gridView.gridArray = manager.getStatus()
        }
    }
    
    func addGridAction(x x: Int, y: Int, index: Int) {
        manager.addStyle(manager.getLiftGameGridStyleFromIndex(index), x: x, y: y)
        gridView.gridArray = manager.getStatus()
    }
    
    // MARK: private methods
    
    func generateNextStatus() {
        manager.generate()
        gridView.gridArray = manager.getStatus()
    }
}
