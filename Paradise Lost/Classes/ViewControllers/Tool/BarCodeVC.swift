//
//  BarCodeVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/30/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit
import AVFoundation

class BarCodeVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate, BarCodeViewDelegate {
    
    var mainView: BarCodeView!
    let captureSession: AVCaptureSession = AVCaptureSession()
    var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    var glassSound: SystemSoundID = 0 // in swift make sure to initialize the ID to 0
    var isSoundOn: Bool = true
    var isVibraOn: Bool = true
    
    var canCapture: Bool = true
    var isCapturing: Bool = false
    
    let captureObjectType = [
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeEAN13Code
    ]
    
    // MARK: life cycle
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return .Portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = BarCodeView(frame: UIScreen.mainScreen().bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        initData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        setupCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initData() {
        if let tmp = UserDefaultManager.valueFromKeyEnum(.BarCodeSoundOn) {
            isSoundOn = tmp as! Bool
        } else {
            isSoundOn = true
        }
        mainView.isSoundOn = isSoundOn
        if let tmp = UserDefaultManager.valueFromKeyEnum(.BarCodeVibraOn) {
            isVibraOn = tmp as! Bool
        } else {
            isVibraOn = true
        }
        mainView.isVibraOn = isVibraOn
        
        if let soundURL = NSBundle.mainBundle().URLForResource("Audio/Glass", withExtension: "aiff") {
            AudioServicesCreateSystemSoundID(soundURL, &glassSound)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.barcode.nosound.message"), handler: nil)
        }
    }
    
    func setupCapture() {
        let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        // input
        var deviceInput = AVCaptureDeviceInput()
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.barcode.initinput.message") + " \(error.localizedDescription).", handler: nil)
            return
        }
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.barcode.noinput.message"), handler: nil)
            return
        }
        // output
        let metaDateOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDateOutput) {
            captureSession.addOutput(metaDateOutput)
            metaDateOutput.setMetadataObjectsDelegate(self, queue: dispatch_get_main_queue())
            metaDateOutput.metadataObjectTypes = captureObjectType
        } else {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.barcode.nooutput.message"), handler: nil)
            return
        }
        captureSession.stopRunning()
        // layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = mainView.reader.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        for metaData in metadataObjects {
            let readableObject = metaData as! AVMetadataMachineReadableCodeObject
            let code = readableObject.stringValue
            
            if !code.isEmpty {
                presentResult(code)
                return
            }
        }
        presentResult("")
    }
    
    // MARK: BarCodeViewDelegate
    
    func tapSoundImage() {
        isSoundOn = !isSoundOn
        UserDefaultManager.setValue(isSoundOn, forKeyEnum: .BarCodeSoundOn)
    }
    
    func tapVibraImage() {
        isVibraOn = !isVibraOn
        UserDefaultManager.setValue(isVibraOn, forKeyEnum: .BarCodeVibraOn)
    }
    
    func tapReader() {
        if canCapture && !isCapturing {
            isCapturing = true
            mainView.reader.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }
    }
    
    func copyButtonAction(result: String?) {
        UIPasteboard.generalPasteboard().string = result
    }
    
    // MARK: event response
    
    func presentResult(result: String) {
        captureSession.stopRunning()
        isCapturing = false
        previewLayer.removeFromSuperlayer()
        if isSoundOn {
            AudioServicesPlaySystemSound(glassSound)
        }
        if isVibraOn {
            AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
        }
        mainView.hasResult(result)
    }
}
