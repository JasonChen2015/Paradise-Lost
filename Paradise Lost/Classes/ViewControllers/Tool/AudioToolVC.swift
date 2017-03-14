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
    let recordSettings = [AVSampleRateKey: NSNumber(float: 44100.0),
                          AVFormatIDKey: NSNumber(unsignedInt: kAudioFormatMPEG4AAC),
                          AVNumberOfChannelsKey: NSNumber(int: 1),
                          AVEncoderAudioQualityKey: NSNumber(long: AVAudioQuality.Medium.rawValue)]
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = AudioToolView(frame: UIScreen.mainScreen().bounds)
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
            try audioPlayer = AVAudioPlayer(contentsOfURL: audioRecorder.url)
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
    }
    
    // MARK: private methods
    
    private func setupAudio() {
        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: soundUrl()!, settings: recordSettings)
        } catch {
            AlertManager.showTips(self, message: "Cannot setup audio tools.", handler: nil)
        }
    }
    
    private func soundUrl() -> NSURL? {
        let fileManager = FileExplorerManager.shareInstance
        let t = fileManager.documentDir.stringByAppendingString("/audio/test.m4a")
        return NSURL(string: t)
    }
}
