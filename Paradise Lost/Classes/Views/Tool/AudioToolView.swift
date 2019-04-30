//
//  AudioToolView.swift
//  Paradise Lost
//
//  Created by jason on 9/3/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit

protocol AudioToolViewDelegate {
    func stopAudio()
    func playAudio()
    func recordAudio()
}

class AudioToolView: UIView {
    
    var delegate: AudioToolViewDelegate? = nil
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        addSubview(nameLabel)
        addSubview(stopButton)
        addSubview(playButton)
        addSubview(recordButton)
        
        stopButton.addTarget(self, action: #selector(AudioToolView.doStop), for: .touchUpInside)
        playButton.addTarget(self, action: #selector(AudioToolView.doPlay), for: .touchUpInside)
        recordButton.addTarget(self, action: #selector(AudioToolView.doRecord), for: .touchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0]-[v1]-[v2]-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": stopButton, "v2":playButton, "v3":recordButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": stopButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": playButton]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": recordButton]))
    }
    
    // MARK: event response
    
    @objc func doStop() {
        delegate?.stopAudio()
    }
    
    @objc func doPlay() {
        delegate?.playAudio()
    }
    
    @objc func doRecord() {
        delegate?.recordAudio()
    }
    
    // MARK: getters and setters
    
    fileprivate var nameLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "audio.namelabel.text")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var stopButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("stop", for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
    fileprivate var playButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("play", for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var recordButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle("record", for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
