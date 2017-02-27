//
//  TextEditorView.swift
//  Paradise Lost
//
//  Created by jason on 29/6/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class TextEditorView: UIView {
    
    /// flag that text of textField or textView has been modified
    var isModified: Bool = false
    /// to store the original frame of view
    private var originFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.whiteColor()
        setupView()
        
        originFrame = self.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setupView() {
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(mainTextView)
        
        nameTextField.delegate = self
        mainTextView.delegate = self
        
        nameLabel.userInteractionEnabled = true
        let tapNameLabelGesture = UITapGestureRecognizer(target: self, action: #selector(TextEditorView.resignAllResponder))
        nameLabel.addGestureRecognizer(tapNameLabelGesture)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[v0(20)]-8-[v1]-69-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": mainTextView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|-84-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameTextField]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0(70)]-8-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": nameTextField]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mainTextView]))
    }
    
    // MARK: event response
    
    func resignAllResponder() {
        // to hide keyboard
        UIApplication.sharedApplication().sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, forEvent: nil)
    }
    
    func showKeyboard(aNotification: NSNotification) {
        let info = aNotification.userInfo! as NSDictionary
        
        guard let keyboardValue = info.objectForKey(UIKeyboardFrameBeginUserInfoKey) else {
            return
        }
        let keyboardRect = keyboardValue.CGRectValue()
        var viewFrame = self.frame
        viewFrame.size = CGSize(width: viewFrame.size.width, height: viewFrame.size.height - keyboardRect.size.height + 49)
        
        guard let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) else {
            return
        }
        let animationDuration = duration.doubleValue
        UIView.animateWithDuration(animationDuration, animations: { (_) -> Void in
            self.frame = viewFrame
        })
    }
    
    func hideKeyboard(aNotification: NSNotification) {
        let info = aNotification.userInfo! as NSDictionary
        guard let duration = info.objectForKey(UIKeyboardAnimationDurationUserInfoKey) else {
            return
        }
        let animationDuration = duration.doubleValue
        UIView.animateWithDuration(animationDuration, animations: { (_) -> Void in
            self.frame = self.originFrame
        })
    }
    
    // MARK: getters and setters
    
    func getFileName() -> String {
        if let name = nameTextField.text {
            // remove the leading and trailing white spaces
            let temp = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
            nameTextField.text = temp
            return temp
        } else {
            return ""
        }
    }
    
    func getFileContent() -> String {
        return mainTextView.text
    }
    
    func loadFile(fileName: String, content: String) {
        nameTextField.text = fileName
        mainTextView.text = content
    }
    
    private var nameLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "texteditor.namelabel.text")
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var nameTextField: UITextField = {
        var textField = UITextField()
        textField.layer.borderColor = Color().LightGray.CGColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private var mainTextView: UITextView = {
        var textView = UITextView()
        textView.layer.borderColor = Color().LightGray.CGColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
}

extension TextEditorView: UITextFieldDelegate, UITextViewDelegate {
    // when tap return at nameTextField, hide keyboard
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        isModified = true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        isModified = true
    }
}
