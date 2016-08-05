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
    
    /// the information of the edited file
    var file: File = File()
    
    private var fileManager = FileExplorerManager() {
        didSet {
            if fileManager.documentDir == "" {
                AlertManager.showTips(self, message: "Can not initialize Text Editor.", handler: { (_) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    return
                })
            }
        }
    }
    private var originFilePath: String = ""
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // navigation bar
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: LanguageManager.getAppLanguageString("tool.texteditor.rightbar.text"), style: .Plain, target: self, action: #selector(TextEditorVC.saveToFile))
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: LanguageManager.getAppLanguageString("tool.texteditor.leftbar.text"), style: .Plain, target: self, action: #selector(TextEditorVC.exitEditor))
        
        mainView = TextEditorView(frame: UIScreen.mainScreen().bounds)
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
            fileManager.createFileWithDirectory(originFilePath)
            mainView.loadFile(file.name, content: "")
        }
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
    
    /**
        all files will be saved at ~/Documents/editor/
     */
    func saveToFile() {
        // user interface
        mainView.resignAllResponder()
        
        // check file name
        let fileName = mainView.getFileName()
        if fileName == "" {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.texteditor.nofilename.message"), handler: nil)
            return
        }
        file.name = fileName
        
        // check file path
        var toFilePath = file.getFullPath()
        if originFilePath != toFilePath {
            if !fileManager.renameFile(originFilePath, newName: mainView.getFileName()) {
                // alert that can not rename the file and will save the file at original path
                AlertManager.showTipsWithContinue(self, message: LanguageManager.getAppLanguageString("tool.texteditor.norename.message"), handler: { (_) -> Void in
                    // do not save
                    return
                }, cHandler: { (_) -> Void in
                    toFilePath = self.originFilePath
                })
            }
        }
        
        // check file exist
        if !fileManager.isFileOrFolderExist(toFilePath) {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.texteditor.savefail.message"), handler: nil)
            return
        }
        
        // write to file
        if fileManager.coverToFile(toFilePath, contents: mainView.getFileContent()) {
            mainView.isModified = false
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.texteditor.savesuccess.message") + " " + file.getFullPath(), handler: nil)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.texteditor.savefail.message"), handler: nil)
        }
    }
    
    func exitEditor() {
        mainView.resignAllResponder()
        if mainView.isModified {
            AlertManager.showTipsWithContinue(self, message: LanguageManager.getAppLanguageString("tool.texteditor.saveforget.message"), handler: nil, cHandler: { (_) -> Void in
                self.navigationController?.popViewControllerAnimated(true)
            })
            return
        }
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
