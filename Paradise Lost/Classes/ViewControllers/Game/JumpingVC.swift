//
//  JumpingVC.swift
//  Paradise Lost
//
//  Created by jason on 5/7/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit
import SpriteKit

class JumpingVC: UIViewController, JumpingSceneDelegate {
    
    // MARK: life cycle
    
    /*
     should change the view into SKView in the loadView method thus can convert the view to SKView in the viewDidLoad
     refer to
     http://stackoverflow.com/questions/31085728/when-programatically-creating-a-viewcontroller-how-can-i-set-its-view-to-be-of/31093001
     */
    override func loadView() {
        self.view = SKView(frame: UIScreen.main.bounds)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = JumpingScene(size: UIScreen.main.bounds.size)
        scene.scaleMode = .resizeFill
        scene.actionDelegate = self
        
        let skView = view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = false
        skView.presentScene(scene)
    }
    
    override var shouldAutorotate : Bool {
        return false
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    // MARK: JumpingSceneDelegate
    
    func exitGame() {
        dismiss(animated: false, completion: nil)
    }
}
