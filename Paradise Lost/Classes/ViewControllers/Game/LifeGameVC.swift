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
    var manager: LifeGameManager!
    
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
        manager.height = 200
        manager.width = 200
        // Glider
        manager.addGliderAtPoint(x: 20, y: 20, axes: .First)
        
        // view
        
        mainView = LifeGameView(frame: UIScreen.mainScreen().bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        gridView = LifeGameGridView(frame: CGRect(x: 7, y: 200, width: 400, height: 400))
        gridView.gridArray = manager.getStatus()
        gridView.gridWidth = manager.height
        gridView.gridHeight = manager.width
        gridView.gridSize = 2
        view.addSubview(gridView)
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
    
    func chooseGridStyle(index: Int) {
        //manager.addStyle()
    }
    
    // MARK: private methods
    
    func generateNextStatus() {
        manager.generate()
        gridView.gridArray = manager.getStatus()
    }
}
