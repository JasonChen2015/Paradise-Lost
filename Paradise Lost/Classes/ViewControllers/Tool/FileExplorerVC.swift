//
//  FileExplorerVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class FileExplorerVC: UIViewController, UICollectionViewDataSource,
                      UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate,
                      UIPopoverPresentationControllerDelegate, FilePopoverViewControllerDelegate {
    
    let cellReuseIdentifier: String = "CollectionViewCell"
    var collectionView: UICollectionView!
    
    /// file explorer manager
    var explorer = FileExplorerManager() {
        didSet {
            if explorer.documentDir == "" {
                AlertManager.showTips(self,
                                      message: LanguageManager.getAppLanguageString("tool.explorer.init.message"),
                                      handler: { (_) -> Void in
                                        self.dismissViewControllerAnimated(true, completion: nil)
                                        return
                })
            }
        }
    }
    
    /// restore the cells
    var items: [File] = []
    
    /// selected item
    var selectedItem: Int = 0
    /// selected fullpath of file to be moved
    var selectedFilePath: String = ""
    
    /// flag the move file action
    var hasMoveFile: Bool = false
    /// store the full path of be-moved file
    var movedFileFullPath: String = ""
    
    /// record the current directory of absolute path
    var currentDir = "" {
        didSet {
            navigationItem.title = currentDir.componentsSeparatedByString("/").last
        }
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // add quick tool
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                            style: .Plain,
                                                            target: self,
                                                            action: #selector(FileExplorerVC.extraOperation))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [NSFontAttributeName: UIFont.boldSystemFontOfSize(28)], forState: .Normal)
        
        // set up collection view
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 90)
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(FileCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // add long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(FileExplorerVC.longPressGesture))
        longPress.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPress)
        
        view.addSubview(collectionView)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCellWithReuseIdentifier(cellReuseIdentifier,
                                                                          forIndexPath: indexPath) as! FileCollectionViewCell
        if indexPath.row == 0 {  // deal with the first item - "button" for upper directory
            aCell.imageView.image = UIImage(named: "UpperDir")
            aCell.nameLabel.text = ""
        } else { // file or folder
            // set image
            let file = items[indexPath.row]
            switch explorer.getFileType(file.getFullPath()) {
            case .Folder:
                aCell.imageView.image = UIImage(named: "Folder")
                break
            case .File:
                aCell.imageView.image = UIImage(named: "File")
            default:
                // maybe the file or folder that has no right to read or write
                aCell.imageView.image = nil
                break
            }
            // set name
            aCell.nameLabel.text = file.name
        }
        return aCell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.row == 0 {  // deal with the first item - "button" for upper directory
            goToUpperDirectory()
        }
        
        let file = items[indexPath.row]
        let fullpath = file.getFullPath()
        switch explorer.getFileType(fullpath) {
        case .Folder:
            // go into the folder
            reloadCell(fullpath)
            break
        case .File:
            // show information of the file
            let df = NSDateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let msg =
                "\(LanguageManager.getAppLanguageString("tool.explorer.fileinfo.path"))=\(file.path)\n" +
                "\(LanguageManager.getAppLanguageString("tool.explorer.fileinfo.name"))=\(file.name)\n" +
                "\(LanguageManager.getAppLanguageString("tool.explorer.fileinfo.size"))=\(file.size)\n" +
                "\(LanguageManager.getAppLanguageString("tool.explorer.fileinfo.createdate"))=\(df.stringFromDate(file.createDate))\n" +
                "\(LanguageManager.getAppLanguageString("tool.explorer.fileinfo.modifydate"))=\(df.stringFromDate(file.modifyDate))"
            AlertManager.showTips(self, message: msg, handler: nil)
            break
        default:
            break
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func longPressGesture(recognize: UILongPressGestureRecognizer) {
        if recognize.state == .Began {
            let point = recognize.locationInView(collectionView)
            if let indexPath = collectionView.indexPathForItemAtPoint(point) {
                // record the selected index of items
                selectedItem = indexPath.row
                if selectedItem != 0 {
                    // action of delete file or move file
                    let file = items[selectedItem]
                    AlertManager.showActionSheetToHandleFile(
                        self,
                        title: "",
                        message: "\(LanguageManager.getAppLanguageString("tool.explorer.longpress.message")) \(file.name)?",
                        openHDL: (explorer.getFileType(file.getFullPath()) == FileExplorerManager.FileType.File) ? openFile : nil,
                        moveHDL: moveFile,
                        deleteHDL: confirmDeleteFile)
                }
            }
        }
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController) -> UIModalPresentationStyle {
        return .None
    }
    
    // MARK: FilePopoverViewControllerDelegate
    
    func didClickCreateButton() {
        // show alert to choose create file or folder
        let alertCtrl = UIAlertController(title: LanguageManager.getAppLanguageString("tool.explorer.create.title"), message: "", preferredStyle: .Alert)
        let cancelAction = UIAlertAction(title: LanguageManager.getAppLanguageString("alert.cancel.title"), style: .Cancel, handler: nil)
        let newFileAction = UIAlertAction(title: LanguageManager.getAppLanguageString("tool.explorer.create.createfile.title"), style: .Default) { (action: UIAlertAction!) -> Void in
            let filename = (alertCtrl.textFields?.first)! as UITextField
            self.createFileOrFolder(filename.text!, isFile: true)
        }
        let newFolderAction = UIAlertAction(title: LanguageManager.getAppLanguageString("tool.explorer.create.createfolder.title"), style: .Default) { (action: UIAlertAction!) -> Void in
            let filename = (alertCtrl.textFields?.first)! as UITextField
            self.createFileOrFolder(filename.text!, isFile: false)
        }
        alertCtrl.addTextFieldWithConfigurationHandler { (filenamne: UITextField!) -> Void in
            filenamne.placeholder = LanguageManager.getAppLanguageString("tool.explorer.create.placeholder")
        }
        alertCtrl.addAction(cancelAction)
        alertCtrl.addAction(newFileAction)
        alertCtrl.addAction(newFolderAction)
        
        // show the alert view
        self.presentViewController(alertCtrl, animated: true, completion: nil)
    }
    
    func didClickPasteButton() {
        hasMoveFile = false
        let aFile = File(absolutePath: movedFileFullPath)
        let destination = "\(currentDir)/\(aFile.name)"
        if explorer.moveFileOrFolder(fromFullPath: movedFileFullPath, toFullPath: destination, willCover: false) {
            // move success
            AlertManager.showTips(self, message: "\(LanguageManager.getAppLanguageString("tool.explorer.paste.success1")) \(movedFileFullPath) \(LanguageManager.getAppLanguageString("tool.explorer.paste.success2")) \(destination)", handler: nil)
            reloadCell(currentDir)
        } else {
            AlertManager.showTips(self, message: "\(LanguageManager.getAppLanguageString("tool.explorer.paste.error1")) \(movedFileFullPath) \(LanguageManager.getAppLanguageString("tool.explorer.paste.error2")) \(destination)", handler: nil)
        }
        movedFileFullPath = ""
    }
    
    // MARK: event response
    
    func goToUpperDirectory() {
        if let upperURL = NSURL(fileURLWithPath: currentDir).URLByDeletingLastPathComponent {
            reloadCell(upperURL.relativePath!)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.explorer.upper.error"), handler: nil)
        }
    }
    
    func extraOperation() {
        // use pop over to show the menu
        let popVC = FilePopoverVC()
        popVC.preferredContentSize = CGSize(width: 90, height: 80)
        popVC.modalPresentationStyle = .Popover
        popVC.delegate = self
        popVC.enablePaste = hasMoveFile
        
        let popPC = popVC.popoverPresentationController
        popPC?.delegate = self
        popPC?.permittedArrowDirections = .Up
        popPC?.sourceView = view
        popPC?.sourceRect = CGRect(x: view.frame.width - 35, y: 50, width: 1, height: 1)
        
        presentViewController(popVC, animated: true, completion: nil)
    }
    
    // UIAlertAction handler for long press item
    
    func openFile(alert: UIAlertAction?) {
        let fullPath = items[selectedItem].getFullPath()
        if explorer.getFileType(fullPath) == FileExplorerManager.FileType.File {
            let vc = TextEditorVC()
            vc.file = File(absolutePath: fullPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func moveFile(alert: UIAlertAction?) {
        hasMoveFile = true
        movedFileFullPath = items[selectedItem].getFullPath()
    }
    
    func confirmDeleteFile(alert: UIAlertAction?) {
        AlertManager.showTipsWithContinue(self,
                                          message: "\(LanguageManager.getAppLanguageString("tool.explorer.delete.message")) \(items[selectedItem].getFullPath())",
                                          handler: nil,
                                          cHandler: deleteFile)
    }
    
    func deleteFile(alert: UIAlertAction) {
        if explorer.removeFileOrFolder(items[selectedItem].getFullPath()) {
            // refresh the user interface
            reloadCell(currentDir)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.explorer.delete.error"), handler: nil)
        }
    }
    
    func createFileOrFolder(fileName: String, isFile: Bool) {
        if fileName == "" {
            // alert nil file name
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.explorer.create.empty"), handler: nil)
        } else {
            let fullPath = "\(currentDir)/\(fileName)"
            if explorer.isFileOrFolderExist(fullPath) {
                // alert the file or folder has existed
                AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.explorer.create.exist"), handler: nil)
            } else {
                if isFile {
                    explorer.createFile(fullPath)
                } else {
                    explorer.createDirectory(fullPath)
                }
                // refresh the items
                reloadCell(currentDir)
            }
        }
    }
    
    // MARK: private methods
    
    private func loadData() {
        // add the "button" at first place for upper directory
        items.insert(File(), atIndex: 0)
        
        currentDir = explorer.documentDir
        let files = explorer.getFileListFromFolder(currentDir)
        for file in files {
            var aFile = File(path: currentDir, name: file)
            aFile.setAttributes()
            items.append(aFile)
        }
    }
    
    private func reloadCell(fullpath: String) {
        // do not go out of the sandbox
        if fullpath == "/var/mobile/Containers/Data/Application" {
            AlertManager.showTips(self, message: LanguageManager.getAppLanguageString("tool.explorer.upper.error"), handler: nil)
            return
        }
        // do enter the folder
        currentDir = fullpath
        
        // delete the old items
        let n = items.count
        for _ in 1..<n {
            items.removeAtIndex(1)
            collectionView.deleteItemsAtIndexPaths([NSIndexPath(forRow: 1, inSection: 0)])
        }
        
        // create the new items
        let filelist = explorer.getFileListFromFolder(fullpath)
        if filelist.count > 0 {
            for i in 0..<filelist.count {
                var aFile = File(path: currentDir, name: filelist[i])
                aFile.setAttributes()
                items.insert(aFile, atIndex: i + 1)
                collectionView.insertItemsAtIndexPaths([NSIndexPath(forRow: i + 1, inSection: 0)])
            }
        }
    }
}

class FileCollectionViewCell: UICollectionViewCell {
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupCell()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: private methods
    
    private func setupCell() {
        addSubview(nameLabel)
        addSubview(imageView)
        
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|-[v0(64)]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[v1(64)]-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": imageView]))
    }
    
    // MARK: getters and setters
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFontOfSize(14)
        label.textAlignment = .Center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.image = UIImage()
        image.translatesAutoresizingMaskIntoConstraints = false
        return image
    }()
}

protocol FilePopoverViewControllerDelegate {
    func didClickCreateButton()
    func didClickPasteButton()
}

class FilePopoverVC: UIViewController {
    
    var delegate: FilePopoverViewControllerDelegate? = nil
    
    var enablePaste: Bool = false
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupComponents()
    }
    
    private func setupComponents() {
        let createBtn = UIButton(type: .System)
        createBtn.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        createBtn.setTitle(LanguageManager.getAppLanguageString("tool.explorer.popover.create"), forState: .Normal)
        createBtn.titleLabel?.textAlignment = .Center
        createBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        createBtn.addTarget(self, action: #selector(tapCreateBtn), forControlEvents: .TouchUpInside)
        view.addSubview(createBtn)
 
        let pasteBtn = UIButton(type: .System)
        pasteBtn.frame = CGRect(x: 0, y: 40, width: 90, height: 40)
        pasteBtn.setTitle(LanguageManager.getAppLanguageString("tool.explorer.popover.paste"), forState: .Normal)
        pasteBtn.titleLabel?.textAlignment = .Center
        pasteBtn.titleLabel?.font = UIFont.boldSystemFontOfSize(16)
        pasteBtn.enabled = enablePaste
        pasteBtn.addTarget(self, action: #selector(tapPasteBtn), forControlEvents: .TouchUpInside)
        view.addSubview(pasteBtn)
    }
    
    // MARK: event response
    
    func tapCreateBtn() {
        dismissViewControllerAnimated(true, completion: {
            self.delegate?.didClickCreateButton()
        })
    }
    
    func tapPasteBtn() {
        dismissViewControllerAnimated(true, completion: {
            self.delegate?.didClickPasteButton()
        })
    }
}
