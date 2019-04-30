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
    
    var timer: Timer = Timer()
    var generateSpeed: Double = 0
    var isGameRunnig: Bool = false
    
    // MARK: life cycle
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        // initial data
        
        manager = LifeGameManager()
        manager.row = 200
        manager.column = 200
        // initial patterns
        manager.addGliderGunAtPoint(x: 20, y: 20)
        
        // view
        
        mainView = LifeGameView(frame: UIScreen.main.bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        gridView = LifeGameGridView(frame: CGRect(x: 7, y: 200, width: 400, height: 400))
        gridView.gridArray = manager.getStatus()
        gridView.gridColumn = manager.row
        gridView.gridRow = manager.column
        gridView.gridSize = 2
        view.addSubview(gridView)
        
        editGridView = LifeGameEditGridView(frame: CGRect(x: 7, y: 168, width: 400, height: 400))
        editGridView.isHidden = true
        view.addSubview(editGridView)
    }
    
    // MARK: LifeGameViewDelegate
    
    func startGameAction(_ isGaming: Bool, speed: Double, gridSize: Int) {
        isGameRunnig = isGaming
        if isGaming {
            gridView.gridSize = gridSize
            generateSpeed = speed
            restartTimer(generateSpeed)
        } else {
            timer.invalidate()
        }
    }
    
    func clearGameAction() {
        if timer.isValid {
            timer.invalidate()
        }
        manager.clearStatus()
        gridView.gridArray = manager.getStatus()
    }
    
    func exitGameAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func editGridAction(x: Int, y: Int) {
        editGridView.isHidden = !editGridView.isHidden
        if !editGridView.isHidden {
            editX = x
            editY = y
            editGridView.gridArray = manager.getEditable(x, y: y, rows: 20, columns: 20)
        } else {
            manager.setEditable(editX, y: editY, rows: 20, columns: 20, array: editGridView.gridArray)
            gridView.gridArray = manager.getStatus()
        }
    }
    
    func addGridAction(x: Int, y: Int, index: Int) {
        manager.addStyle(manager.getLiftGameGridStyleFromIndex(index), x: x, y: y)
        gridView.gridArray = manager.getStatus()
    }
    
    // MARK: private methods
    
    func restartTimer(_ speed: Double) {
        timer.invalidate()
        timer = Timer.scheduledTimer(timeInterval: speed, target: self, selector: #selector(LifeGameVC.generateNextStatus), userInfo: nil, repeats: false)
    }
    
    @objc func generateNextStatus() {
        manager.generate()
        gridView.gridArray = manager.getStatus()
        DispatchQueue.main.async {
            if self.isGameRunnig {
                self.restartTimer(self.generateSpeed)
            }
        }
    }
}
