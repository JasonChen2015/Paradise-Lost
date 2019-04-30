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
    fileprivate var originFrame: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
        
        originFrame = self.frame
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        addSubview(nameLabel)
        addSubview(nameTextField)
        addSubview(mainTextView)
        
        nameTextField.delegate = self
        mainTextView.delegate = self
        
        nameLabel.isUserInteractionEnabled = true
        let tapNameLabelGesture = UITapGestureRecognizer(target: self, action: #selector(TextEditorView.resignAllResponder))
        nameLabel.addGestureRecognizer(tapNameLabelGesture)
    }
    
    override func layoutSubviews() {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0(20)]-8-[v1]-69-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": mainTextView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-84-[v0(20)]", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0(70)]-8-[v1]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": nameTextField]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[v0]-20-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": mainTextView]))
    }
    
    // MARK: event response
    
    @objc func resignAllResponder() {
        // to hide keyboard
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func showKeyboard(_ aNotification: Notification) {
        let info = aNotification.userInfo! as NSDictionary
        
        guard let keyboardValue = info.object(forKey: UIKeyboardFrameBeginUserInfoKey) else {
            return
        }
        let keyboardRect = (keyboardValue as AnyObject).cgRectValue
        var viewFrame = self.frame
        viewFrame.size = CGSize(width: viewFrame.size.width, height: viewFrame.size.height - (keyboardRect?.size.height)! + 49)
        
        guard let duration = info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) else {
            return
        }
        let animationDuration = (duration as AnyObject).doubleValue
        UIView.animate(withDuration: animationDuration!, animations: { () -> Void in
            self.frame = viewFrame
        })
    }
    
    func hideKeyboard(_ aNotification: Notification) {
        let info = aNotification.userInfo! as NSDictionary
        guard let duration = info.object(forKey: UIKeyboardAnimationDurationUserInfoKey) else {
            return
        }
        let animationDuration = (duration as AnyObject).doubleValue
        UIView.animate(withDuration: animationDuration!, animations: { () -> Void in
            self.frame = self.originFrame
        })
    }
    
    // MARK: getters and setters
    
    func getFileName() -> String {
        if let name = nameTextField.text {
            // remove the leading and trailing white spaces
            let temp = name.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            nameTextField.text = temp
            return temp
        } else {
            return ""
        }
    }
    
    func getFileContent() -> String {
        return mainTextView.text
    }
    
    func loadFile(_ fileName: String, content: String) {
        nameTextField.text = fileName
        mainTextView.text = content
    }
    
    fileprivate var nameLabel: UILabel = {
        var label = UILabel()
        label.text = LanguageManager.getToolString(forKey: "texteditor.namelabel.text")
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .right
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate var nameTextField: UITextField = {
        var textField = UITextField()
        textField.layer.borderColor = Color().LightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.layer.cornerRadius = 5.0
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    fileprivate var mainTextView: UITextView = {
        var textView = UITextView()
        textView.layer.borderColor = Color().LightGray.cgColor
        textView.layer.borderWidth = 0.5
        textView.layer.cornerRadius = 5.0
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
}

extension TextEditorView: UITextFieldDelegate, UITextViewDelegate {
    // when tap return at nameTextField, hide keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        isModified = true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        isModified = true
    }
}
