//
//  MarqueeView.swift
//  Paradise Lost
//
//  Created by jason on 10/8/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

protocol MarqueeViewDelegate {
    func willShowFullScreenMarquee(text: String, colorText: UIColor, colorBackground: UIColor, speedMode: MarqueeLabel.SpeedLimit)
}

class MarqueeView: UIView, UITextFieldDelegate {
    
    var delegate: MarqueeViewDelegate?
    
    var textColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var backColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var speedMode: MarqueeLabel.SpeedLimit = MarqueeLabel.SpeedLimit.Duration(7)
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.whiteColor()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        addSubview(nameLabel)
        addSubview(colorSegment)
        addSubview(redSlider)
        addSubview(redText)
        addSubview(greenSlider)
        addSubview(greenText)
        addSubview(blueSlider)
        addSubview(blueText)
        addSubview(alphaSlider)
        addSubview(alphaText)
        addSubview(contentLabel)
        addSubview(contentText)
        addSubview(speedLabel)
        addSubview(speedSegment)
        addSubview(speedText)
        addSubview(unitLabel)
        addSubview(preview)
        addSubview(showBtn)
        
        redText.delegate = self
        greenText.delegate = self
        blueText.delegate = self
        alphaText.delegate = self
        contentText.delegate = self
        speedText.delegate = self
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(MarqueeView.resignAllResponder))
        addGestureRecognizer(tapView)
        
        colorSegment.addTarget(self, action: #selector(MarqueeView.didChangeColorSegment), forControlEvents: .ValueChanged)
        speedSegment.addTarget(self, action: #selector(MarqueeView.didChangeSpeedSegment), forControlEvents: .ValueChanged)
        
        redSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), forControlEvents: .ValueChanged)
        greenSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), forControlEvents: .ValueChanged)
        blueSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), forControlEvents: .ValueChanged)
        alphaSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), forControlEvents: .ValueChanged)
        
        redText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), forControlEvents: .EditingDidEnd)
        greenText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), forControlEvents: .EditingDidEnd)
        blueText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), forControlEvents: .EditingDidEnd)
        alphaText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), forControlEvents: .EditingDidEnd)
        
        contentText.addTarget(self, action: #selector(MarqueeView.refreshPreview), forControlEvents: .EditingDidEnd)
        speedText.addTarget(self, action: #selector(MarqueeView.didChangeSpeedText), forControlEvents: .EditingDidEnd)
        
        showBtn.addTarget(self, action: #selector(MarqueeView.didTouchShowButton), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorSegment]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": redSlider, "v1": redText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": greenSlider, "v1": greenText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": blueSlider, "v1": blueText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": alphaSlider, "v1": alphaText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-[v1(300)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedLabel, "v1": speedSegment]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-[v1(30)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedText, "v1": unitLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-60-[v0(288)]-8-[v1(38)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": preview, "v1": showBtn]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-68-[v0(30)]-20-[v1(30)]-[v2(30)]-[v3(30)]-[v4(30)]-[v5(30)]-20-[v6(30)]-[v7(30)]-20-[v8(30)]-[v9(30)]-20-[v10(162)]-78-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": colorSegment, "v2": redSlider, "v3": greenSlider, "v4": blueSlider, "v5": alphaSlider, "v6": contentLabel, "v7": contentText, "v8": speedLabel, "v9": speedText, "v10": preview]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-156-[v0(30)]-[v1(30)]-[v2(30)]-[v3(30)]-108-[v4(30)]-[v5(30)]-152-[v6(30)]-78-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": redText, "v1": greenText, "v2": blueText, "v3": alphaText, "v4": speedSegment, "v5": unitLabel, "v6": showBtn]))
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: event response
    
    func resignAllResponder() {
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }
    
    // for view controller initialization
    func setColorSegment(selectedIndex: Int) {
        if selectedIndex == 1 {
            colorSegment.selectedSegmentIndex = 1
        } else {
            colorSegment.selectedSegmentIndex = 0
        }
        didChangeColorSegment()
    }
    
    // for view controller initialization
    func setSpeedSegment(selectedIndex: Int) {
        if selectedIndex == 1 {
            speedSegment.selectedSegmentIndex = 1
        } else {
            speedSegment.selectedSegmentIndex = 0
        }
        didChangeSpeedSegment()
    }
    
    func didChangeColorSegment() {
        if colorSegment.selectedSegmentIndex == 0 {
            redSlider.value = Float(textColor.RGBComponents.red)
            greenSlider.value = Float(textColor.RGBComponents.green)
            blueSlider.value = Float(textColor.RGBComponents.blue)
            alphaSlider.value = Float(textColor.RGBComponents.alpha)
        } else if colorSegment.selectedSegmentIndex == 1 {
            redSlider.value = Float(backColor.RGBComponents.red)
            greenSlider.value = Float(backColor.RGBComponents.green)
            blueSlider.value = Float(backColor.RGBComponents.blue)
            alphaSlider.value = Float(backColor.RGBComponents.alpha)
        }
        refreshColorTextFromSlider()
    }
    
    func didChangeColorSlider(sender: AnyObject) {
        switch sender.tag {
        case 100:
            redText.text = "\(redSlider.value)"
            break
        case 101:
            greenText.text = "\(greenSlider.value)"
            break
        case 102:
            blueText.text = "\(blueSlider.value)"
            break
        case 103:
            alphaText.text = "\(alphaSlider.value)"
            break
        default:
            return
        }
        saveColor()
        refreshPreview()
    }
    
    func didChangeColorText(sender: AnyObject) {
        switch sender.tag {
        case 200:
            redSlider.value = transferRGBValueFromText(redText.text)
            didChangeColorSlider(redSlider)
            break
        case 201:
            greenSlider.value = transferRGBValueFromText(greenText.text)
            didChangeColorSlider(greenSlider)
            break
        case 202:
            blueSlider.value = transferRGBValueFromText(blueText.text)
            didChangeColorSlider(blueSlider)
            break
        case 203:
            alphaSlider.value = transferRGBValueFromText(alphaText.text)
            didChangeColorSlider(alphaSlider)
            break
        default:
            return
        }
    }
    
    func didChangeSpeedSegment() {
        if speedSegment.selectedSegmentIndex == 0 {
            // point per second
            speedMode = .Rate(transferSpeedFromText(speedText.text))
            unitLabel.text = "p/s"
        } else if speedSegment.selectedSegmentIndex == 1 {
            // second per time
            speedMode = .Duration(transferSpeedFromText(speedText.text))
            unitLabel.text = "s"
        }
        refreshPreview()
    }
    
    func didChangeSpeedText() {
        didChangeSpeedSegment()
    }
    
    func didTouchShowButton() {
        delegate?.willShowFullScreenMarquee(contentText.text!, colorText: textColor, colorBackground: backColor, speedMode: speedMode)
    }
    
    // MARK: private methods
    
    private func transferRGBValueFromText(text: String?) -> Float {
        if text != nil {
            if var color = Float(text!) {
                if color < 0 {
                    color = 0
                }
                if color > 1 {
                    color = 1
                }
                return color
            }
            return 0
        } else {
            return 0
        }
    }
    
    private func saveColor() {
        let currentColor = UIColor(colorLiteralRed: redSlider.value,
                                   green: greenSlider.value, blue: blueSlider.value, alpha: alphaSlider.value)
        if colorSegment.selectedSegmentIndex == 0 {
            textColor = currentColor
        } else if colorSegment.selectedSegmentIndex == 1 {
            backColor = currentColor
        }
    }
    
    private func refreshColorTextFromSlider() {
        redText.text = "\(redSlider.value)"
        greenText.text = "\(greenSlider.value)"
        blueText.text = "\(blueSlider.value)"
        alphaText.text = "\(alphaSlider.value)"
    }
    
    private func transferSpeedFromText(text: String?) -> CGFloat {
        if text != nil {
            if let speed = Float(text!) {
                return CGFloat(speed)
            } else {
                return 0
            }
        } else {
            return 0
        }
    }
    
    func refreshPreview() {
        preview.textColor = textColor
        preview.backgroundColor = backColor
        preview.text = contentText.text
        preview.speed = speedMode
        preview.setNeedsDisplay()
    }
    
    // MARK: getters and setters
    
    private var nameLabel: UILabel = {
       let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "marquee.namelabel.text")
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var colorSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegmentWithTitle(LanguageManager.getToolString(forKey: "marquee.colorseg.text"), atIndex: 0, animated: true)
        segment.insertSegmentWithTitle(LanguageManager.getToolString(forKey: "marquee.colorseg.back"), atIndex: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private var redSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 100
        slider.tintColor = UIColor.redColor()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var redText: UITextField = {
        let text = UITextField()
        text.tag = 200
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var greenSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 101
        slider.tintColor = UIColor.greenColor()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var greenText: UITextField = {
        let text = UITextField()
        text.tag = 201
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var blueSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 102
        slider.tintColor = UIColor.blueColor()
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var blueText: UITextField = {
        let text = UITextField()
        text.tag = 202
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var alphaSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 103
        slider.tintColor = Color().LightGray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    private var alphaText: UITextField = {
        let text = UITextField()
        text.tag = 203
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var contentLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "marquee.contentlabel.text")
        label.textAlignment = .Left
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var contentText: UITextField = {
        let text = UITextField()
        text.text = LanguageManager.getToolString(forKey: "marquee.contenttext.text")
        text.font = UIFont.systemFontOfSize(18)
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var speedLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "marquee.speedlabel.text")
        label.textAlignment = .Left
        label.font = UIFont.systemFontOfSize(16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var speedSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegmentWithTitle(LanguageManager.getToolString(forKey: "marquee.speedseg.rate"), atIndex: 0, animated: true)
        segment.insertSegmentWithTitle(LanguageManager.getToolString(forKey: "marquee.speedseg.duration"), atIndex: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    private var speedText: UITextField = {
        let text = UITextField()
        text.text = "7"
        text.textAlignment = .Right
        text.font = UIFont.systemFontOfSize(18)
        text.keyboardType = .NumbersAndPunctuation
        text.layer.borderColor = Color().LightGray.CGColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    private var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "s"
        label.font = UIFont.systemFontOfSize(14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var preview: MarqueeLabel = {
        let label = MarqueeLabel()
        label.layer.borderColor = Color().LightGray.CGColor
        label.layer.borderWidth = 1.0
        label.font = UIFont.boldSystemFontOfSize(130)
        label.type = .Continuous
        label.animationCurve = .Linear
        label.animationDelay = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var showBtn: UIButton = {
        let button = UIButton(type: .System)
        button.setTitle(LanguageManager.getToolString(forKey: "marquee.showbtn.title"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
