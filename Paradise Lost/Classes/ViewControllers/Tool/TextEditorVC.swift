//
//  TextEditorVC.swift
//  Paradise Lost
//
//  Created by jason on 29/6/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class TextEditorVC: UIViewController {
    
    var mainView: TextEditorView!
    var isEdit: Bool = false
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: "Save", style: .Plain, target: self, action: #selector(TextEditorVC.saveToFile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Return", style: .Plain, target: self, action: #selector(TextEditorVC.exitEditor))
        
        mainView = TextEditorView(frame: UIScreen.mainScreen().bounds)
        view.addSubview(mainView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: #selector(TextEditorVC.keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(
            self, selector: #selector(TextEditorVC.keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
        super.viewWillDisappear(animated)
    }
    
    // MARK: event response
    
    func saveToFile() {
        
    }
    
    func exitEditor() {
        self.navigationController?.popViewControllerAnimated(true)
    }
    
    func keyboardWillShow(aNotification: NSNotification) {
        if isEdit {
            return
        }
        mainView.showKeyboard(aNotification)
        isEdit = true
    }
    
    func keyboardWillHide(aNotification: NSNotification) {
        if !isEdit {
            return
        }
        mainView.hideKeyboard(aNotification)
        isEdit = false
    }
}
