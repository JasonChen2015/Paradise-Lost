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
        
        tileView = TwoZeroFourEightV(frame: UIScreen.mainScreen().bounds)
        tileView.delegate = self
        
        let panGesture = UIPanGestureRecognizer(target: self, action: "handlePanGesture:")
        panGesture.maximumNumberOfTouches = 1
        panGesture.minimumNumberOfTouches = 1
        tileView.addGestureRecognizer(panGesture)
        
        view.addSubview(tileView)
        
        // for test
        let val = 2 << Int(arc4random_uniform(10))
        tiles[2] = val
        
        refreshTileView()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    // MARK: TwoZeroFourEightViewDelegate
    
    func newButtonAction() {
        //
    }
    
    func exitButtonAction() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: event response
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        // TODO: the animation of merging
        if sender.state == .Ended {
            let velocity = sender.velocityInView(self.view)
            // ignore the case when x == y
            if fabs(velocity.x) > fabs(velocity.y) {
                // horizontal
                if velocity.x > 0 {
                    TileItemManager.mergeAsideFromItems(tiles, atDirection: .Right)
                    lastDirection = .Right
                    refreshTileView()
                } else if velocity.x < 0 {
                    TileItemManager.mergeAsideFromItems(tiles, atDirection: .Left)
                    lastDirection = .Left
                    refreshTileView()
                }
            } else if fabs(velocity.x) < fabs(velocity.y) {
                // vertical
                if velocity.y > 0 {
                    TileItemManager.mergeAsideFromItems(tiles, atDirection: .Down)
                    lastDirection = .Down
                    refreshTileView()
                } else if velocity.y < 0 {
                    TileItemManager.mergeAsideFromItems(tiles, atDirection: .Up)
                    lastDirection = .Up
                    refreshTileView()
                }
            }
        }
    }
    
    // MARK: private methods
    
    func refreshTileView() {
        for index in 0...15 {
            tileView.setValueOfTile(index, value: tiles[index])
        }
    }
}
