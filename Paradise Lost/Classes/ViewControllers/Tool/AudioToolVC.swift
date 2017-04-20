//
//  AudioToolVC.swift
//  Paradise Lost
//
//  Created by jason on 9/3/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit
import AVFoundation

class AudioToolVC: UIViewController, AudioToolViewDelegate {
    
    var mainView: AudioToolView!
    
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    let recordSettings = [AVSampleRateKey: NSNumber(value: 44100.0 as Float),
                          AVFormatIDKey: NSNumber(value: kAudioFormatMPEG4AAC as UInt32),
                          AVNumberOfChannelsKey: NSNumber(value: 1 as Int32),
                          AVEncoderAudioQualityKey: NSNumber(value: AVAudioQuality.medium.rawValue as Int)]
    var timer: Timer!
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = AudioToolView(frame: UIScreen.main.bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        setupAudio()
    }
    
    // MARK: AudioToolViewDelegate
    
    func stopAudio() {
        if let audioRecorder = audioRecorder {
            audioRecorder.stop()
        }
        if let audioPlayer = audioPlayer {
            audioPlayer.stop()
        }
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(false)
        } catch {
            AlertManager.showTips(self, message: "Cannot stop audio.", handler: nil)
        }
    }
    
    func playAudio() {
        stopAudio()
        do {
            try audioPlayer = AVAudioPlayer(contentsOf: audioRecorder.url)
            audioPlayer.play()
        } catch {
            AlertManager.showTips(self, message: "Cannot play audio.", handler: nil)
        }
    }
    
    func recordAudio() {
        stopAudio()
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setActive(true)
            audioRecorder.record()
        } catch {
            AlertManager.showTips(self, message: "Cannot record audio.", handler: nil)
        }
        
        // set timer to force quit record
        resetTimer()
    }
    
    // MARK: private methods
    
    fileprivate func resetTimer() {
        if timer != nil {
            timer.invalidate()
        }
        timer = Timer(timeInterval: 60.0, target: self, selector: #selector(AudioToolVC.stopAudio), userInfo: nil, repeats: false)
    }
    
    fileprivate func setupAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(url: soundUrl()!, settings: recordSettings)
        } catch {
            AlertManager.showTips(self, message: "Cannot setup audio tools.", handler: nil)
        }
    }
    
    fileprivate func soundUrl() -> URL? {
        let fileManager = FileExplorerManager.shareInstance
        let t = fileManager.documentDir + "/audio/test.m4a"
        return URL(string: t)
    }
}
