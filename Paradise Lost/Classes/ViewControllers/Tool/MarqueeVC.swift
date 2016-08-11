//
//  MarqueeVC.swift
//  Paradise Lost
//
//  Created by jason on 10/8/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class MarqueeVC: UIViewController, MarqueeViewDelegate {
    
    var mainView: MarqueeView!
    
    // MARK: life cycle
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = MarqueeView(frame: UIScreen.mainScreen().bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        // initialise
        mainView.setColorSegment(0)
        mainView.setSpeedSegment(1)
        mainView.refreshPreview()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // diable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.enabled = false
    }
    
    override func viewWillDisappear(animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.enabled = true
        super.viewWillDisappear(animated)
    }
    
    // MARK: MarqueeViewDelegate
    
    func willShowFullScreenMarquee(text: String, colorText: UIColor, colorBackground: UIColor, speedMode: MarqueeLabel.SpeedLimit) {
        let newViewCtrl = MarqueeFullVC()
        newViewCtrl.initialText(text, textColor: colorText, backgroundColor: colorBackground)
        newViewCtrl.initialRunMode(speedMode)
        presentViewController(newViewCtrl, animated: false, completion: nil)
    }
}

class MarqueeFullVC: UIViewController {
    
    private var mainLabel: MarqueeLabel!
    private var textColor: UIColor!
    private var backgroundColor: UIColor!
    private var mainText: String!
    private var speedLimit: MarqueeLabel.SpeedLimit!
    
    // MARK: life cycle
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func shouldAutorotate() -> Bool {
        return true
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .LandscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = UIScreen.mainScreen().bounds
        // show in landscape right
        mainLabel = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: rect.height, height: rect.width))
        mainLabel.font = UIFont.boldSystemFontOfSize(230)
        mainLabel.textColor = textColor
        mainLabel.backgroundColor = backgroundColor
        mainLabel.text = mainText
        mainLabel.speed = speedLimit
        mainLabel.animationCurve = .Linear
        mainLabel.animationDelay = 0.0
        view.addSubview(mainLabel)
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(MarqueeFullVC.viewTouchDown(_:)))
        view.addGestureRecognizer(viewGesture)
        
        // do not let the screen display closed until dismiss
        UIApplication.sharedApplication().idleTimerDisabled = true
    }
    
    // MARK: event response
    
    func viewTouchDown(recognizer: UITapGestureRecognizer) {
        UIApplication.sharedApplication().idleTimerDisabled = false
        dismissViewControllerAnimated(false, completion: nil)
    }
    
    // MARK: getters and setters
    
    func initialText(mainText: String, textColor: UIColor, backgroundColor: UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.mainText = mainText
    }
    
    func initialRunMode(speedLimit: MarqueeLabel.SpeedLimit) {
        self.speedLimit = speedLimit
    }
}
