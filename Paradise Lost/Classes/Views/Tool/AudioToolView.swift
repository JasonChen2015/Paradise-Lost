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
        
        self.backgroundColor = UIColor.whiteColor()
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        addSubview(nameLabel)
        addSubview(stopButton)
        addSubview(playButton)
        addSubview(recordButton)
        
        stopButton.addTarget(self, action: #selector(AudioToolView.doStop), forControlEvents: .TouchUpInside)
        playButton.addTarget(self, action: #selector(AudioToolView.doPlay), forControlEvents: .TouchUpInside)
        recordButton.addTarget(self, action: #selector(AudioToolView.doRecord), forControlEvents: .TouchUpInside)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[v0]-[v1]-[v2]-[v3]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": stopButton, "v2":playButton, "v3":recordButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": stopButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": playButton]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v0]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": recordButton]))
    }
    
    // MARK: event response
    
    func doStop() {
        delegate?.stopAudio()
    }
    
    func doPlay() {
        delegate?.playAudio()
    }
    
    func doRecord() {
        delegate?.recordAudio()
    }
    
    // MARK: getters and setters
    
    private var nameLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "audio.namelabel.text")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var stopButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("stop", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
 
    private var playButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("play", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var recordButton: UIButton = {
        var button = UIButton(type: .System)
        button.setTitle("record", forState: .Normal)
        button.exclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}
