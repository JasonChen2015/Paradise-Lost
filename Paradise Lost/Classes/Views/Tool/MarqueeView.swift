//
//  MarqueeView.swift
//  Paradise Lost
//
//  Created by jason on 10/8/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

protocol MarqueeViewDelegate {
    func willShowFullScreenMarquee(_ text: String, colorText: UIColor, colorBackground: UIColor, speedMode: MarqueeLabel.SpeedLimit)
}

class MarqueeView: UIView, UITextFieldDelegate {
    
    var delegate: MarqueeViewDelegate?
    
    var textColor: UIColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
    var backColor: UIColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
    var speedMode: MarqueeLabel.SpeedLimit = MarqueeLabel.SpeedLimit.duration(7)
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
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
        
        colorSegment.addTarget(self, action: #selector(MarqueeView.didChangeColorSegment), for: .valueChanged)
        speedSegment.addTarget(self, action: #selector(MarqueeView.didChangeSpeedSegment), for: .valueChanged)
        
        redSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), for: .valueChanged)
        greenSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), for: .valueChanged)
        blueSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), for: .valueChanged)
        alphaSlider.addTarget(self, action: #selector(MarqueeView.didChangeColorSlider(_:)), for: .valueChanged)
        
        redText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), for: .editingDidEnd)
        greenText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), for: .editingDidEnd)
        blueText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), for: .editingDidEnd)
        alphaText.addTarget(self, action: #selector(MarqueeView.didChangeColorText(_:)), for: .editingDidEnd)
        
        contentText.addTarget(self, action: #selector(MarqueeView.refreshPreview), for: .editingDidEnd)
        speedText.addTarget(self, action: #selector(MarqueeView.didChangeSpeedText), for: .editingDidEnd)
        
        showBtn.addTarget(self, action: #selector(MarqueeView.didTouchShowButton), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": colorSegment]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": redSlider, "v1": redText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": greenSlider, "v1": greenText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": blueSlider, "v1": blueText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(300)]-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": alphaSlider, "v1": alphaText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": contentText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-[v1(300)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedLabel, "v1": speedSegment]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-[v1(30)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": speedText, "v1": unitLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[v0(288)]-8-[v1(38)]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": preview, "v1": showBtn]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-68-[v0(30)]-20-[v1(30)]-[v2(30)]-[v3(30)]-[v4(30)]-[v5(30)]-20-[v6(30)]-[v7(30)]-20-[v8(30)]-[v9(30)]-20-[v10(162)]-78-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": colorSegment, "v2": redSlider, "v3": greenSlider, "v4": blueSlider, "v5": alphaSlider, "v6": contentLabel, "v7": contentText, "v8": speedLabel, "v9": speedText, "v10": preview]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-156-[v0(30)]-[v1(30)]-[v2(30)]-[v3(30)]-108-[v4(30)]-[v5(30)]-152-[v6(30)]-78-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": redText, "v1": greenText, "v2": blueText, "v3": alphaText, "v4": speedSegment, "v5": unitLabel, "v6": showBtn]))
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    // MARK: event response
    
    @objc func resignAllResponder() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    // for view controller initialization
    func setColorSegment(_ selectedIndex: Int) {
        if selectedIndex == 1 {
            colorSegment.selectedSegmentIndex = 1
        } else {
            colorSegment.selectedSegmentIndex = 0
        }
        didChangeColorSegment()
    }
    
    // for view controller initialization
    func setSpeedSegment(_ selectedIndex: Int) {
        if selectedIndex == 1 {
            speedSegment.selectedSegmentIndex = 1
        } else {
            speedSegment.selectedSegmentIndex = 0
        }
        didChangeSpeedSegment()
    }
    
    @objc func didChangeColorSegment() {
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
    
    @objc func didChangeColorSlider(_ sender: AnyObject) {
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
    
    @objc func didChangeColorText(_ sender: AnyObject) {
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
    
    @objc func didChangeSpeedSegment() {
        if speedSegment.selectedSegmentIndex == 0 {
            // point per second
            speedMode = .rate(transferSpeedFromText(speedText.text))
            unitLabel.text = "p/s"
        } else if speedSegment.selectedSegmentIndex == 1 {
            // second per time
            speedMode = .duration(transferSpeedFromText(speedText.text))
            unitLabel.text = "s"
        }
        refreshPreview()
    }
    
    @objc func didChangeSpeedText() {
        didChangeSpeedSegment()
    }
    
    @objc func didTouchShowButton() {
        delegate?.willShowFullScreenMarquee(contentText.text!, colorText: textColor, colorBackground: backColor, speedMode: speedMode)
    }
    
    // MARK: private methods
    
    fileprivate func transferRGBValueFromText(_ text: String?) -> Float {
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
    
    fileprivate func saveColor() {
        let currentColor = UIColor(_colorLiteralRed: redSlider.value,
                                   green: greenSlider.value, blue: blueSlider.value, alpha: alphaSlider.value)
        if colorSegment.selectedSegmentIndex == 0 {
            textColor = currentColor
        } else if colorSegment.selectedSegmentIndex == 1 {
            backColor = currentColor
        }
    }
    
    fileprivate func refreshColorTextFromSlider() {
        redText.text = "\(redSlider.value)"
        greenText.text = "\(greenSlider.value)"
        blueText.text = "\(blueSlider.value)"
        alphaText.text = "\(alphaSlider.value)"
    }
    
    fileprivate func transferSpeedFromText(_ text: String?) -> CGFloat {
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
    
    @objc func refreshPreview() {
        preview.textColor = textColor
        preview.backgroundColor = backColor
        preview.text = contentText.text
        preview.speed = speedMode
        preview.setNeedsDisplay()
    }
    
    // MARK: getters and setters
    
    fileprivate var nameLabel: UILabel = {
       let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "marquee.namelabel.text")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var colorSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: LanguageManager.getToolString(forKey: "marquee.colorseg.text"), at: 0, animated: true)
        segment.insertSegment(withTitle: LanguageManager.getToolString(forKey: "marquee.colorseg.back"), at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    fileprivate var redSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 100
        slider.tintColor = UIColor.red
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    fileprivate var redText: UITextField = {
        let text = UITextField()
        text.tag = 200
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var greenSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 101
        slider.tintColor = UIColor.green
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    fileprivate var greenText: UITextField = {
        let text = UITextField()
        text.tag = 201
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var blueSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 102
        slider.tintColor = UIColor.blue
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    fileprivate var blueText: UITextField = {
        let text = UITextField()
        text.tag = 202
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var alphaSlider: UISlider = {
        let slider = UISlider()
        slider.tag = 103
        slider.tintColor = Color().LightGray
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    fileprivate var alphaText: UITextField = {
        let text = UITextField()
        text.tag = 203
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var contentLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "marquee.contentlabel.text")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var contentText: UITextField = {
        let text = UITextField()
        text.text = LanguageManager.getToolString(forKey: "marquee.contenttext.text")
        text.font = UIFont.systemFont(ofSize: 18)
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var speedLabel: UILabel = {
        let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "marquee.speedlabel.text")
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var speedSegment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: LanguageManager.getToolString(forKey: "marquee.speedseg.rate"), at: 0, animated: true)
        segment.insertSegment(withTitle: LanguageManager.getToolString(forKey: "marquee.speedseg.duration"), at: 1, animated: true)
        segment.translatesAutoresizingMaskIntoConstraints = false
        return segment
    }()
    
    fileprivate var speedText: UITextField = {
        let text = UITextField()
        text.text = "7"
        text.textAlignment = .right
        text.font = UIFont.systemFont(ofSize: 18)
        text.keyboardType = .numbersAndPunctuation
        text.layer.borderColor = Color().LightGray.cgColor
        text.layer.borderWidth = 1.0
        text.translatesAutoresizingMaskIntoConstraints = false
        return text
    }()
    
    fileprivate var unitLabel: UILabel = {
        let label = UILabel()
        label.text = "s"
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var preview: MarqueeLabel = {
        let label = MarqueeLabel()
        label.layer.borderColor = Color().LightGray.cgColor
        label.layer.borderWidth = 1.0
        label.font = UIFont.boldSystemFont(ofSize: 130)
        label.type = .continuous
        label.animationCurve = .linear
        label.animationDelay = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var showBtn: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(LanguageManager.getToolString(forKey: "marquee.showbtn.title"), for: UIControlState())
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
