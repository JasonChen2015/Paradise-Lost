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
    func copyButtonAction(_ result: String?)
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
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.isSoundOn = true
        self.isVibraOn = true
        
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
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
        
        clearButton.addTarget(self, action: #selector(BarCodeView.clearResult), for: .touchUpInside)
        copyButton.addTarget(self, action: #selector(BarCodeView.copyResult), for: .touchUpInside)
        
        let soundTap = UITapGestureRecognizer(target: self, action: #selector(BarCodeView.changeSound))
        soundImage.addGestureRecognizer(soundTap)
        let vibraTap = UITapGestureRecognizer(target: self, action: #selector(BarCodeView.changeVibra))
        vibraImage.addGestureRecognizer(vibraTap)
        
        let gesture = UITapGestureRecognizer(target: self, action: #selector(BarCodeView.tapReader))
        reader.addGestureRecognizer(gesture)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0(40)]-20-[v1(334)]-[v2(30)]-[v3(54)]-[v4(25)]-20-[v5(36)]-69-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel, "v1": reader, "v2": resultLabel, "v3": resultText, "v4": clearButton, "v5": soundImage]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-586-[v0(25)]-20-[v1(36)]-69-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": copyButton, "v1": vibraImage]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[v0(334)]-40-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": reader]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": resultText]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-150-[v0(53)]-[v1(53)]-150-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": clearButton, "v1": copyButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(36)]-20-[v1(36)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": soundImage, "v1": vibraImage]))
    }
    
    // MARK: event response
    
    func clearResult() {
        resultText.text = LanguageManager.getToolString(forKey: "barcode.resulttext.text")
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
    
    func hasResult(_ result: String) {
        if result.isEmpty {
            resultText.text = LanguageManager.getToolString(forKey: "barcode.resulttext.text")
        } else {
            resultText.text = result
        }
    }
    
    // MARK: getters and setters
    
    fileprivate var titleLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "barcode.titlelabel.text")
        label.font = UIFont.boldSystemFont(ofSize: 36)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    var reader: UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "barcode.reader.label.text")
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        let width = NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 300)
        let height = NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 20)
        let centerX = NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: view, attribute: .centerX, multiplier: 1, constant: 0)
        let centerY = NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([width, height, centerX, centerY])
        
        return view
    }()
    
    fileprivate var resultLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "barcode.resultlabel.text")
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var resultText: UITextView = {
        var textView = UITextView()
        textView.text = LanguageManager.getToolString(forKey: "barcode.resulttext.text")
        textView.textAlignment = .center
        textView.font = UIFont.systemFont(ofSize: 20)
        textView.isUserInteractionEnabled = false
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    fileprivate var clearButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getPublicString(forKey: "clear"), for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var copyButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getPublicString(forKey: "copy"), for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var soundImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "SoundOn")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var vibraImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "VibraOn")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
}
