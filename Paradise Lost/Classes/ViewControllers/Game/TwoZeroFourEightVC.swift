//
//  TwoZeroFourEightVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class TwoZeroFourEightVC: UIViewController, TwoZeroFourEightViewDelegate {
    
    var tiles: [Int] = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
    var lastDirection: TileItemManager.Direction = .None
    var score: Int = 0
    var highScore: Int = 0
    var tileView: TwoZeroFourEightV!
    
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
        view.backgroundColor = UIColor.whiteColor()
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        
        tileView = TwoZeroFourEightV(frame: UIScreen.mainScreen().bounds)
        tileView.delegate = self
        tileView.addGestureRecognizer(panGesture)
        view.addSubview(tileView)
        
        initialData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func initialData() {
        (tiles, _) = TileItemManager.addANewValueToTile(tiles)
        (tiles, _) = TileItemManager.addANewValueToTile(tiles)
        refreshTileView()
        
        tileView.setValueOfScore(0)
        refreshScore()
        
        if let tmp = UserDefaultManager.valueFromKeyEnum(.TZFEHighScore) {
            highScore = tmp as! Int
        } else {
            highScore = 0
        }
        refreshHighScore()
    }
    
    // MARK: TwoZeroFourEightViewDelegate
    
    func newButtonAction() {
        // TODO: should has tips
        initialData()
    }
    
    func exitButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: event response
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        // TODO: the animation of merging
        if sender.state == .Ended {
            let velocity = sender.velocityInView(self.view)
            lastDirection = .None
            // ignore the case when x == y
            if fabs(velocity.x) > fabs(velocity.y) {
                // horizontal
                if velocity.x > 0 {
                    lastDirection = .Right
                } else if velocity.x < 0 {
                    lastDirection = .Left
                }
            } else if fabs(velocity.x) < fabs(velocity.y) {
                // vertical
                if velocity.y > 0 {
                    lastDirection = .Down
                } else if velocity.y < 0 {
                    lastDirection = .Up
                }
            }
            var temp = 0
            var hasMove = false
            var hasPos = true
            (tiles, temp, hasMove) = TileItemManager.mergeAsideFromItems(tiles, atDirection: lastDirection)
            if hasMove {
                score = score + temp
                refreshScore()
                if score > highScore {
                    highScore = score
                    UserDefaultManager.setValue(highScore, forKeyEnum: .TZFEHighScore)
                    refreshHighScore()
                }
                (tiles, hasPos) = TileItemManager.addANewValueToTile(tiles)
                refreshTileView()
            }
            if !hasPos {
                gameOver()
            }
        }
    }
    
    // MARK: private methods
    
    func refreshTileView() {
        for index in 0...15 {
            tileView.setValueOfTile(index, value: tiles[index])
        }
    }
    
    func refreshScore() {
        tileView.setValueOfScore(score)
    }
    
    func refreshHighScore() {
        tileView.setValueOfHighScore(highScore)
    }
    
    func gameOver() {
        // TODO: should show tips
        initialData()
    }
}
