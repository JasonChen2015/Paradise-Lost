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
    fileprivate var isEdit: Bool = false
    
    /// the information of the edited file
    var file: File = File()
    
    fileprivate var fileManager = FileExplorerManager.shareInstance {
        didSet {
            if fileManager.documentDir == "" {
                AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "texteditor.openfail.message"), handler: { (_) -> Void in
                    self.dismiss(animated: true, completion: nil)
                    return
                })
            }
        }
    }
    fileprivate var originFilePath: String = ""
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: LanguageManager.getToolString(forKey: "texteditor.rightbar.text"), style: .plain, target: self, action: #selector(TextEditorVC.saveToFile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: LanguageManager.getPublicString(forKey: "return"), style: .plain, target: self, action: #selector(TextEditorVC.exitEditor))
        
        mainView = TextEditorView(frame: UIScreen.main.bounds)
        view.addSubview(mainView)
        
        // load data
        if file.name == "" {
            let filePath = fileManager.documentDir + "/editor"
            file = File(path: filePath, name: "untitled.txt")
        }
        originFilePath = file.getFullPath()
        if fileManager.isFileOrFolderExist(originFilePath) {
            let text = fileManager.getUTF8FileContent(file.getFullPath())
            mainView.loadFile(file.name, content: text)
        } else {
            let _ = fileManager.createFileWithDirectory(originFilePath)
            mainView.loadFile(file.name, content: "")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(
            self, selector: #selector(TextEditorVC.keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(
            self, selector: #selector(TextEditorVC.keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
        super.viewWillDisappear(animated)
    }
    
    // MARK: event response
    
    /**
        all files will be saved at ~/Documents/editor/
     */
    func saveToFile() {
        // user interface
        mainView.resignAllResponder()
        
        // check file name
        let fileName = mainView.getFileName()
        if fileName == "" {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "texteditor.nofilename.message"), handler: nil)
            return
        }
        file.name = fileName
        
        // check file path
        var toFilePath = file.getFullPath()
        if originFilePath != toFilePath {
            if !fileManager.renameFile(originFilePath, newName: mainView.getFileName()) {
                // alert that can not rename the file and will save the file at original path
                AlertManager.showTipsWithContinue(self, message: LanguageManager.getToolString(forKey: "texteditor.norename.message"), handler: { (_) -> Void in
                    // do not save
                    return
                }, cHandler: { (_) -> Void in
                    toFilePath = self.originFilePath
                })
            }
        }
        
        // check file exist
        if !fileManager.isFileOrFolderExist(toFilePath) {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "texteditor.savefail.message"), handler: nil)
            return
        }
        
        // write to file
        if fileManager.coverToFile(toFilePath, contents: mainView.getFileContent()) {
            mainView.isModified = false
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "texteditor.savesuccess.message") + " " + file.getFullPath(), handler: nil)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "texteditor.savefail.message"), handler: nil)
        }
    }
    
    func exitEditor() {
        mainView.resignAllResponder()
        if mainView.isModified {
            AlertManager.showTipsWithContinue(self, message: LanguageManager.getToolString(forKey: "texteditor.saveforget.message"), handler: nil, cHandler: { (_) -> Void in
                self.navigationController?.popViewController(animated: true)
            })
            return
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func keyboardWillShow(_ aNotification: Notification) {
        if isEdit {
            return
        }
        mainView.showKeyboard(aNotification)
        isEdit = true
    }
    
    func keyboardWillHide(_ aNotification: Notification) {
        if !isEdit {
            return
        }
        mainView.hideKeyboard(aNotification)
        isEdit = false
    }
}
