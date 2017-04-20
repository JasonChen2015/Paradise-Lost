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
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = MarqueeView(frame: UIScreen.main.bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        // initialise
        mainView.setColorSegment(0)
        mainView.setSpeedSegment(1)
        mainView.refreshPreview()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // diable back swipe gesture
        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        super.viewWillDisappear(animated)
    }
    
    // MARK: MarqueeViewDelegate
    
    func willShowFullScreenMarquee(_ text: String, colorText: UIColor, colorBackground: UIColor, speedMode: MarqueeLabel.SpeedLimit) {
        let newViewCtrl = MarqueeFullVC()
        newViewCtrl.initialText(text, textColor: colorText, backgroundColor: colorBackground)
        newViewCtrl.initialRunMode(speedMode)
        present(newViewCtrl, animated: false, completion: nil)
    }
}

class MarqueeFullVC: UIViewController {
    
    fileprivate var mainLabel: MarqueeLabel!
    fileprivate var textColor: UIColor!
    fileprivate var backgroundColor: UIColor!
    fileprivate var mainText: String!
    fileprivate var speedLimit: MarqueeLabel.SpeedLimit!
    
    // MARK: life cycle
    
    override var prefersStatusBarHidden : Bool {
        return true
    }
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .landscapeRight
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = UIScreen.main.bounds
        // show in landscape right
        mainLabel = MarqueeLabel(frame: CGRect(x: 0, y: 0, width: rect.height, height: rect.width))
        mainLabel.font = UIFont.boldSystemFont(ofSize: 230)
        mainLabel.textColor = textColor
        mainLabel.backgroundColor = backgroundColor
        mainLabel.text = mainText
        mainLabel.speed = speedLimit
        mainLabel.animationCurve = .linear
        mainLabel.animationDelay = 0.0
        view.addSubview(mainLabel)
        
        let viewGesture = UITapGestureRecognizer(target: self, action: #selector(MarqueeFullVC.viewTouchDown(_:)))
        view.addGestureRecognizer(viewGesture)
        
        // do not let the screen display closed until dismiss
        UIApplication.shared.isIdleTimerDisabled = true
    }
    
    // MARK: event response
    
    func viewTouchDown(_ recognizer: UITapGestureRecognizer) {
        UIApplication.shared.isIdleTimerDisabled = false
        dismiss(animated: false, completion: nil)
    }
    
    // MARK: getters and setters
    
    func initialText(_ mainText: String, textColor: UIColor, backgroundColor: UIColor) {
        self.textColor = textColor
        self.backgroundColor = backgroundColor
        self.mainText = mainText
    }
    
    func initialRunMode(_ speedLimit: MarqueeLabel.SpeedLimit) {
        self.speedLimit = speedLimit
    }
}
