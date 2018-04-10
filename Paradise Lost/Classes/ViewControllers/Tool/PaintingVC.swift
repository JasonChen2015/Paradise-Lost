//
//  PaintingVC.swift
//  Paradise Lost
//
//  Created by jason on 26/9/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit

class PaintingVC: UIViewController, PaintingViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var mainView: PaintingView!
    var toolView: PaintingToolView!
    var colorView: PaintingColorView!
    
    /// flag of current picture whether has been saved
    var isCurrentPicSave: Bool = true
    
    // MARK: life cycle
    
    override var prefersStatusBarHidden: Bool {
        get {
            return true
        }
     }
    
    override var shouldAutorotate : Bool {
        return true
    }
    override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let rect = UIScreen.main.bounds
        let toolheigh = rect.height / 13
        let colorheight = CGFloat(40)
        
        mainView = PaintingView(frame: rect)
        mainView.delegate = self
        view.addSubview(mainView)
        
        toolView = PaintingToolView(frame: CGRect(x: 0, y: (rect.height - toolheigh), width: rect.width, height: toolheigh))
        toolView.delegate = self
        view.addSubview(toolView)
        
        colorView = PaintingColorView(frame: CGRect(x: 0, y: (rect.height - toolheigh - colorheight), width: rect.width, height: colorheight))
        colorView.isHidden = true
        view.addSubview(colorView)
    }
    
    // MARK: PaintingViewDelegate
    
    func exit() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func savePic() {
        savePicToPhotoLibrary(nil)
    }
    
    func getPic() {
        if (mainView.hasImage && !isCurrentPicSave) {
            AlertManager.showTipsWithContinue(self, message: LanguageManager.getToolString(forKey: "paint.getImage.message"), handler: savePicToPhotoLibrary, cHandler: nil)
        }
        getPicFromPhotoLibrary()
    }
    
    func changePenMode() {
        if (toolView.currentMode == .pen) {
            colorView.isHidden = false
        } else {
            colorView.isHidden = true
        }
    }
    
    func changeResizeMode() {
        colorView.isHidden = true
    }
    
    func changeTextMode() {
        colorView.isHidden = true
    }
    
    // MARK: UIImagePickerControllerDelegate
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            mainView.loadImage(rawImage: image)
            isCurrentPicSave = false
        } else if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            mainView.loadImage(rawImage: image)
            isCurrentPicSave = false
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "paint.getImage.error"), handler: nil)
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: private methods
    
    fileprivate func getPicFromPhotoLibrary() {
        let picker = UIImagePickerController()
        picker.delegate = self
        //picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        
        self.present(picker, animated: true, completion: nil)
    }
    
    fileprivate func savePicToPhotoLibrary(_ alert: UIAlertAction?) {
        if let image = mainView.getImage() {
            UIImageWriteToSavedPhotosAlbum(image, self, #selector(PaintingVC.image(_:didFinishSavingWithError:contextInfo:)), nil)
        }
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let _ = error {
            // fail
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "paint.saveImage.fail"), handler: nil)
        } else {
            // success
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "paint.saveImage.success"), handler: nil)
            isCurrentPicSave = true
        }
    }
}
