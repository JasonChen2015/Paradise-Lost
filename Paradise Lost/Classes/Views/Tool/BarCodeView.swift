//
//  BarCodeView.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/30/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

protocol BarCodeViewDelegate {
    func tapSoundImage()
    func tapVibraImage()
    func copyButtonAction(result: String?)
    func tapReader()
}

class BarCodeView: UIView {
    
    var delegate: BarCodeViewDelegate? = nil
    var isSoundOn: Bool {
        didSet {
            if isSoundOn {
                soundImage.image = UIImage(named: "SoundOn")
            } else {
                soundImage.image = UIImage(named: "SoundOff")
            }
        }
    }
    var isVibraOn: Bool {
        didSet {
            if isVibraOn {
                vibraImage.image = UIImage(named: "VibraOn")
            } else {
                vibraImage.image = UIImage(named: "VibraOff")
            }
        }
    }
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        self.isSoundOn = true
        self.isVibraOn = true
        
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isSoundOn = true
        self.isVibraOn = true
        
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        // subview
        addSubview(titleLabel)
        addSubview(reader)
        addSubview(resultLabel)
        addSubview(resultText)
        addSubview(clearButton)
        addSubview(copyButton)
        addSubview(soundImage)
        addSubview(vibraImage)
        
        // action
        
        clearButton.addTarget(self, action: #selector(BarCodeView.clearResult), forControlEvents: .TouchUpInside)
        copyButton.addTarget(self, action: #selector(BarCodeView.copyResult), forControlEvents: .TouchUpInside)
        
        let soundTap = UITapGestureRecognizer(target: self, action: #selector(BarCodeView.changeSound))
        soundImage.addGestureRecognizer(soundTap)
        let vibraTap = UITapGestureRecognizer(target: self, action: #selector(BarCodeView.changeVibra))
        vibraImage.addGestureRecognizer(vibraTap)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(BarCodeView.tapReader))
        reader.addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[v0(40)]-20-[v1(334)]-[v2(30)]-[v3(54)]-[v4(25)]-20-[v5(36)]-69-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": reader, "v2": resultLabel, "v3": resultText, "v4": clearButton, "v5": soundImage]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-586-[v0(25)]-20-[v1(36)]-69-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": copyButton, "v1": vibraImage]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-40-[v0(334)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": reader]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultText]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-150-[v0(53)]-[v1(53)]-150-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": clearButton, "v1": copyButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(36)]-20-[v1(36)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": soundImage, "v1": vibraImage]))
    }
    
    // MARK: event response
    
    func clearResult() {
        resultText.text = LanguageManager.getAppLanguageString("tool.barcode.resulttext.text")
    }
    
    func copyResult() {
        delegate?.copyButtonAction(resultText.text)
    }
    
    func changeSound() {
        isSoundOn = !isSoundOn
        delegate?.tapSoundImage()
    }
    
    func changeVibra() {
        isVibraOn = !isVibraOn
        delegate?.tapVibraImage()
    }
    
    func tapReader() {
        delegate?.tapReader()
    }
    
    func hasResult(result: String) {
        if result.isEmpty {
            resultText.text = LanguageManager.getAppLanguageString("tool.barcode.resulttext.text")
        } else {
            resultText.text = result
        }
    }
    
    // MARK: getters and setters
    
    private var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("tool.barcode.titlelabel.text")
        label.font = UIFont.boldSystemFontOfSize(36)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var reader: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = LanguageManager.getAppLanguageString("tool.barcode.reader.label.text")
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let width = NSLayoutConstraint(item: label, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300)
        let height = NSLayoutConstraint(item: label, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 20)
        let centerX = NSLayoutConstraint(item: label, attribute: .CenterX, relatedBy: .Equal, toItem: view, attribute: .CenterX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: label, attribute: .CenterY, relatedBy: .Equal, toItem: view, attribute: .CenterY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activateConstraints([width, height, centerX, centerY])
        
        return view
    }()
    
    private var resultLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getAppLanguageString("tool.barcode.resultlabel.text")
        label.font = UIFont.boldSystemFontOfSize(20)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var resultText: UITextView = {
        var textView = UITextView()
        textView.text = LanguageManager.getAppLanguageString("tool.barcode.resulttext.text")
        textView.textAlignment = .Center
        textView.font = UIFont.systemFontOfSize(20)
        textView.userInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private var clearButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getAppLanguageString("tool.barcode.clearbutton.title"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var copyButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle(LanguageManager.getAppLanguageString("tool.barcode.copybutton.title"), forState: .Normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var soundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "SoundOn")
        imageView.userInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private var vibraImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "VibraOn")
        imageView.userInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
