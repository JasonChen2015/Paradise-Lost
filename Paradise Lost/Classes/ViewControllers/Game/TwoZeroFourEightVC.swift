//
//  TwoZeroFourEightVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class TwoZeroFourEightVC: UIViewController, TwoZeroFourEightViewDelegate {
    
    var tiles: [TileItem] = []
    var lastDirection: TileItemManager.Direction = .none
    
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
        
        let v = TwoZeroFourEightV(frame: UIScreen.mainScreen().bounds)
        v.delegate = self
        view.addSubview(v)
        
        // for test
        let val = 2 << Int(arc4random_uniform(10))
        tiles[0] = TileItem(value: val)
        v.setValueOfTile(0, value: val)
        
        for index in 1...15 {
            tiles[index] = TileItem(value: 0)
            v.setValueOfTile(index, value: 0)
        }
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
}
