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
    fileprivate let captureSession: AVCaptureSession = AVCaptureSession()
    fileprivate var previewLayer: AVCaptureVideoPreviewLayer = AVCaptureVideoPreviewLayer()
    
    fileprivate var glassSound: SystemSoundID = 0 // in swift make sure to initialize the ID to 0
    fileprivate var isSoundOn: Bool = true
    fileprivate var isVibraOn: Bool = true
    
    fileprivate var canCapture: Bool = true
    fileprivate var isCapturing: Bool = false
    
    fileprivate let captureObjectType = [
        AVMetadataObjectTypeUPCECode,
        AVMetadataObjectTypeQRCode,
        AVMetadataObjectTypeEAN8Code,
        AVMetadataObjectTypeEAN13Code
    ]
    
    // MARK: life cycle
    
    override var shouldAutorotate : Bool {
        return true
    }
    
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView = BarCodeView(frame: UIScreen.main.bounds)
        mainView.delegate = self
        view.addSubview(mainView)
        
        initData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCapture()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    fileprivate func initData() {
        if let tmp = UserDefaultManager.objectFromKeyEnum(.barCodeSoundOn) {
            isSoundOn = tmp as! Bool
        } else {
            isSoundOn = true
        }
        mainView.isSoundOn = isSoundOn
        if let tmp = UserDefaultManager.objectFromKeyEnum(.barCodeVibraOn) {
            isVibraOn = tmp as! Bool
        } else {
            isVibraOn = true
        }
        mainView.isVibraOn = isVibraOn
        
        if let soundURL = Bundle.main.url(forResource: "Audio/Glass", withExtension: "aiff") {
            AudioServicesCreateSystemSoundID(soundURL as CFURL, &glassSound)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "barcode.nosound.message"), handler: nil)
        }
    }
    
    fileprivate func setupCapture() {
        let device = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo)
        // input
        var deviceInput = AVCaptureDeviceInput()
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch let error as NSError {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "barcode.initinput.message") + " \(error.localizedDescription).", handler: nil)
            return
        }
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "barcode.noinput.message"), handler: nil)
            return
        }
        // output
        let metaDateOutput = AVCaptureMetadataOutput()
        if captureSession.canAddOutput(metaDateOutput) {
            captureSession.addOutput(metaDateOutput)
            metaDateOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            metaDateOutput.metadataObjectTypes = captureObjectType
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "barcode.nooutput.message"), handler: nil)
            return
        }
        captureSession.stopRunning()
        // layer
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = mainView.reader.bounds
        previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
    }
    
    // MARK: AVCaptureMetadataOutputObjectsDelegate
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [Any]!, from connection: AVCaptureConnection!) {
        for metaData in metadataObjects {
            let readableObject = metaData as! AVMetadataMachineReadableCodeObject
            let code = readableObject.stringValue
            
            if !(code?.isEmpty)! {
                presentResult(code!)
                return
            }
        }
        presentResult("")
    }
    
    // MARK: BarCodeViewDelegate
    
    func tapSoundImage() {
        isSoundOn = !isSoundOn
        UserDefaultManager.setObject(isSoundOn as AnyObject, forKeyEnum: .barCodeSoundOn)
    }
    
    func tapVibraImage() {
        isVibraOn = !isVibraOn
        UserDefaultManager.setObject(isVibraOn as AnyObject, forKeyEnum: .barCodeVibraOn)
    }
    
    func tapReader() {
        if canCapture && !isCapturing {
            isCapturing = true
            mainView.reader.layer.addSublayer(previewLayer)
            captureSession.startRunning()
        }
    }
    
    func copyButtonAction(_ result: String?) {
        UIPasteboard.general.string = result
    }
    
    // MARK: event response
    
    func presentResult(_ result: String) {
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
