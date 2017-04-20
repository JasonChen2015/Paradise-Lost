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
    var lastTiles: [Int] = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
    var score: Int = 0
    var highScore: Int = 0
    var tileView: TwoZeroFourEightView!
    
    // MARK: life cycle
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(TwoZeroFourEightVC.handlePanGesture(_:)))
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        
        tileView = TwoZeroFourEightView(frame: UIScreen.main.bounds)
        tileView.delegate = self
        tileView.addGestureRecognizer(panGesture)
        view.addSubview(tileView)
        
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // judge the current state of tiles
        if !TZFEManager.hasMoveOnTiles(tiles) {
            gameOver()
        }
    }
    
    fileprivate func initData() {
        lastTiles = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
        // tiles
        if let tmp = UserDefaultManager.objectFromKeyEnum(.tzfeTilesRecord) {
            tiles = tmp as! [Int]
        } else {
            tiles = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
            tiles = TZFEManager.addANewValueToTile(tiles)
            tiles = TZFEManager.addANewValueToTile(tiles)
        }
        refreshTileView()
        // score
        if let tmp = UserDefaultManager.objectFromKeyEnum(.tzfeScoreRecord) {
            score = tmp as! Int
        } else {
            score = 0
        }
        refreshScore()
        // high score
        if let tmp = UserDefaultManager.objectFromKeyEnum(.tzfeHighScore) {
            highScore = tmp as! Int
        } else {
            highScore = 0
        }
        refreshHighScore()
    }
    
    fileprivate func resetData(_ alert: UIAlertAction?) {
        lastTiles = [-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1,-1]
        tiles = [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
        tiles = TZFEManager.addANewValueToTile(tiles)
        tiles = TZFEManager.addANewValueToTile(tiles)
        refreshTileView()
        
        score = 0
        refreshScore()
        
        // save to user default
        UserDefaultManager.setObject(tiles as AnyObject, forKeyEnum: .tzfeTilesRecord)
        UserDefaultManager.setObject(score as AnyObject, forKeyEnum: .tzfeScoreRecord)
    }
    
    // MARK: TwoZeroFourEightViewDelegate
    
    func newButtonAction() {
        AlertManager.showTips(self,
            message: LanguageManager.getGameString(forKey: "2048.newbutton.message"), handler: resetData)
    }
    
    func exitButtonAction() {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: event response
    
    func handlePanGesture(_ sender: UIPanGestureRecognizer) {
        if sender.state == .ended {
            let velocity = sender.velocity(in: self.view)
            var direction: TZFEManager.Direction = .none
            // ignore the case when x == y
            if fabs(velocity.x) > fabs(velocity.y) {
                // horizontal
                if velocity.x > 0 {
                    direction = .right
                } else if velocity.x < 0 {
                    direction = .left
                }
            } else if fabs(velocity.x) < fabs(velocity.y) {
                // vertical
                if velocity.y > 0 {
                    direction = .down
                } else if velocity.y < 0 {
                    direction = .up
                }
            }
            // try to move
            var temp = 0
            var hasMove = false
            lastTiles = tiles
            (tiles, temp, hasMove) = TZFEManager.mergeAsideFromItems(tiles, atDirection: direction)
            
            // judge the action of merge
            if hasMove {
                score = score + temp
                refreshScore()
                if score > highScore {
                    highScore = score
                    UserDefaultManager.setObject(highScore as AnyObject, forKeyEnum: .tzfeHighScore)
                    refreshHighScore()
                }
                tiles = TZFEManager.addANewValueToTile(tiles)
                refreshTileView()
                
                UserDefaultManager.setObject(tiles as AnyObject, forKeyEnum: .tzfeTilesRecord)
                UserDefaultManager.setObject(score as AnyObject, forKeyEnum: .tzfeScoreRecord)
            }
            if !TZFEManager.hasMoveOnTiles(tiles) {
                gameOver()
            }
        }
    }
    
    fileprivate func refreshTileView() {
        for index in 0...15 {
            // if no change then not set value
            if lastTiles[index] != tiles[index] {
                tileView.setValueOfTile(index, value: tiles[index])
            }
        }
    }
    
    func refreshScore() {
        tileView.setValueOfScore(score)
    }
    
    func refreshHighScore() {
        tileView.setValueOfHighScore(highScore)
    }
    
    func gameOver() {
        AlertManager.showTips(self,
            message: LanguageManager.getGameString(forKey: "2048.gameover.message"), handler: resetData)
    }
}
