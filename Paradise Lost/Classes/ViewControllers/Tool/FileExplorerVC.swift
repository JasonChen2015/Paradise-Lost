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
    
    fileprivate let cellReuseIdentifier: String = "CollectionViewCell"
    var collectionView: UICollectionView!
    
    /// file explorer manager
    var explorer = FileExplorerManager.shareInstance {
        didSet {
            if explorer.documentDir == "" {
                AlertManager.showTips(self,
                                      message: LanguageManager.getToolString(forKey: "explorer.init.message"),
                                      handler: { (_) -> Void in
                                        self.dismiss(animated: true, completion: nil)
                                        return
                })
            }
        }
    }
    
    /// restore the cells
    fileprivate var items: [File] = []
    
    /// selected item
    fileprivate var selectedItem: Int = 0
    /// selected fullpath of file to be moved
    fileprivate var selectedFilePath: String = ""
    
    /// flag the move file action
    fileprivate var hasMoveFile: Bool = false
    /// store the full path of be-moved file
    fileprivate var movedFileFullPath: String = ""
    
    /// record the current directory of absolute path
    fileprivate var currentDir = "" {
        didSet {
            navigationItem.title = currentDir.components(separatedBy: "/").last
        }
    }
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
        // add quick tool
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(FileExplorerVC.extraOperation))
        navigationItem.rightBarButtonItem?.setTitleTextAttributes(
            [NSFontAttributeName: UIFont.boldSystemFont(ofSize: 28)], for: UIControlState())
        
        // set up collection view
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 90)
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.register(FileCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
        // add long press gesture
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(FileExplorerVC.longPressGesture(_:)))
        longPress.minimumPressDuration = 0.5
        collectionView.addGestureRecognizer(longPress)
        
        view.addSubview(collectionView)
    }
    
    // MARK: UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let aCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellReuseIdentifier,
                                                                          for: indexPath) as! FileCollectionViewCell
        if indexPath.row == 0 {  // deal with the first item - "button" for upper directory
            aCell.imageView.image = UIImage(named: "UpperDir")
            aCell.nameLabel.text = ""
        } else { // file or folder
            // set image
            let file = items[indexPath.row]
            switch explorer.getFileType(file.getFullPath()) {
            case .folder:
                aCell.imageView.image = UIImage(named: "Folder")
                break
            case .file:
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {  // deal with the first item - "button" for upper directory
            goToUpperDirectory()
        }
        
        let file = items[indexPath.row]
        let fullpath = file.getFullPath()
        switch explorer.getFileType(fullpath) {
        case .folder:
            // go into the folder
            reloadCell(fullpath)
            break
        case .file:
            // show information of the file
            let df = DateFormatter()
            df.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let msg =
                "\(LanguageManager.getToolString(forKey: "explorer.fileinfo.path"))=\(file.path)\n" +
                "\(LanguageManager.getToolString(forKey: "explorer.fileinfo.name"))=\(file.name)\n" +
                "\(LanguageManager.getToolString(forKey: "explorer.fileinfo.size"))=\(file.size)\n" +
                "\(LanguageManager.getToolString(forKey: "explorer.fileinfo.createdate"))=\(df.string(from: file.createDate))\n" +
                "\(LanguageManager.getToolString(forKey: "explorer.fileinfo.modifydate"))=\(df.string(from: file.modifyDate))"
            AlertManager.showTips(self, message: msg, handler: nil)
            break
        default:
            break
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func longPressGesture(_ recognize: UILongPressGestureRecognizer) {
        if recognize.state == .began {
            let point = recognize.location(in: collectionView)
            if let indexPath = collectionView.indexPathForItem(at: point) {
                // record the selected index of items
                selectedItem = indexPath.row
                if selectedItem != 0 {
                    // action of delete file or move file
                    let file = items[selectedItem]
                    AlertManager.showActionSheetToHandleFile(
                        self,
                        title: "",
                        message: "\(LanguageManager.getToolString(forKey: "explorer.longpress.message")) \(file.name)?",
                        openHDL: (explorer.getFileType(file.getFullPath()) == FileExplorerManager.FileType.file) ? openFile : nil,
                        moveHDL: moveFile,
                        renameDL: renameFile,
                        deleteHDL: confirmDeleteFile)
                }
            }
        }
    }
    
    // MARK: UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    // MARK: FilePopoverViewControllerDelegate
    
    func didClickCreateButton() {
        // show alert to choose create file or folder
        let alertCtrl = UIAlertController(title: LanguageManager.getToolString(forKey: "explorer.create.title"), message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "cancel"), style: .cancel, handler: nil)
        let newFileAction = UIAlertAction(title: LanguageManager.getToolString(forKey: "explorer.create.createfile.title"), style: .default) { (action: UIAlertAction!) -> Void in
            let filename = (alertCtrl.textFields?.first)! as UITextField
            self.createFileOrFolder(filename.text!, isFile: true)
        }
        let newFolderAction = UIAlertAction(title: LanguageManager.getToolString(forKey: "explorer.create.createfolder.title"), style: .default) { (action: UIAlertAction!) -> Void in
            let filename = (alertCtrl.textFields?.first)! as UITextField
            self.createFileOrFolder(filename.text!, isFile: false)
        }
        alertCtrl.addTextField { (filenamne: UITextField!) -> Void in
            filenamne.placeholder = LanguageManager.getToolString(forKey: "explorer.create.placeholder")
        }
        alertCtrl.addAction(cancelAction)
        alertCtrl.addAction(newFileAction)
        alertCtrl.addAction(newFolderAction)
        
        // show the alert view
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    func didClickPasteButton() {
        hasMoveFile = false
        let aFile = File(absolutePath: movedFileFullPath)
        let destination = "\(currentDir)/\(aFile.name)"
        if explorer.moveFileOrFolder(fromFullPath: movedFileFullPath, toFullPath: destination, willCover: false) {
            // move success
            AlertManager.showTips(self, message: "\(LanguageManager.getToolString(forKey: "explorer.paste.success1")) \(movedFileFullPath) \(LanguageManager.getToolString(forKey: "explorer.paste.success2")) \(destination)", handler: nil)
            reloadCell(currentDir)
        } else {
            AlertManager.showTips(self, message: "\(LanguageManager.getToolString(forKey: "explorer.paste.error1")) \(movedFileFullPath) \(LanguageManager.getToolString(forKey: "explorer.paste.error2")) \(destination)", handler: nil)
        }
        movedFileFullPath = ""
    }
    
    // MARK: event response
    
    func goToUpperDirectory() {
        if let upperURL = NSURL(fileURLWithPath: currentDir).deletingLastPathComponent {
            reloadCell(upperURL.relativePath)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "explorer.upper.error"), handler: nil)
        }
    }
    
    func extraOperation() {
        // use pop over to show the menu
        let popVC = FilePopoverVC()
        popVC.preferredContentSize = CGSize(width: 90, height: 80)
        popVC.modalPresentationStyle = .popover
        popVC.delegate = self
        popVC.enablePaste = hasMoveFile
        
        let popPC = popVC.popoverPresentationController
        popPC?.delegate = self
        popPC?.permittedArrowDirections = .up
        popPC?.sourceView = view
        popPC?.sourceRect = CGRect(x: view.frame.width - 35, y: 50, width: 1, height: 1)
        
        present(popVC, animated: true, completion: nil)
    }
    
    // UIAlertAction handler for long press item
    
    func openFile(_ alert: UIAlertAction?) {
        let fullPath = items[selectedItem].getFullPath()
        if explorer.getFileType(fullPath) == FileExplorerManager.FileType.file {
            let vc = TextEditorVC()
            vc.file = File(absolutePath: fullPath)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func moveFile(_ alert: UIAlertAction?) {
        hasMoveFile = true
        movedFileFullPath = items[selectedItem].getFullPath()
    }
    
    func renameFile(_ alert: UIAlertAction?) {
        let alertCtrl = UIAlertController(title: LanguageManager.getAlertString(forKey: "rename"), message: LanguageManager.getToolString(forKey: "explorer.rename.message"), preferredStyle: .alert)
        alertCtrl.addTextField { (textField: UITextField!) -> Void in
            let file = self.items[self.selectedItem]
            textField.placeholder = file.name
            textField.text = file.name
        }
        let confirmAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "confirm"), style: .default) { (action: UIAlertAction!) -> Void in
            var result = LanguageManager.getToolString(forKey: "explorer.rename.fail")
            if let textField = alertCtrl.textFields?.first {
                let file = self.items[self.selectedItem]
                if file.name == textField.text! {
                    result = LanguageManager.getToolString(forKey: "explorer.rename.nochange")
                } else if self.explorer.renameFile(file.getFullPath(), newName: textField.text!) {
                    // rename success
                    result = LanguageManager.getToolString(forKey: "explorer.rename.success")
                    self.reloadCell(self.currentDir)
                }
            }
            AlertManager.showTips(self, message: result, handler: nil)
        }
        let cancelAction = UIAlertAction(title: LanguageManager.getAlertString(forKey: "cancel"), style: .cancel, handler: nil)
        alertCtrl.addAction(confirmAction)
        alertCtrl.addAction(cancelAction)
        
        self.present(alertCtrl, animated: true, completion: nil)
    }
    
    func confirmDeleteFile(_ alert: UIAlertAction?) {
        AlertManager.showTipsWithContinue(self,
                                          message: "\(LanguageManager.getToolString(forKey: "explorer.delete.message")) \(items[selectedItem].getFullPath())",
                                          handler: nil,
                                          cHandler: deleteFile)
    }
    
    func deleteFile(_ alert: UIAlertAction) {
        if explorer.removeFileOrFolder(items[selectedItem].getFullPath()) {
            // refresh the user interface
            reloadCell(currentDir)
        } else {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "explorer.delete.error"), handler: nil)
        }
    }
    
    func createFileOrFolder(_ fileName: String, isFile: Bool) {
        if fileName == "" {
            // alert nil file name
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "explorer.create.empty"), handler: nil)
        } else {
            let fullPath = "\(currentDir)/\(fileName)"
            if explorer.isFileOrFolderExist(fullPath) {
                // alert the file or folder has existed
                AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "explorer.create.exist"), handler: nil)
            } else {
                if isFile {
                    let _ = explorer.createFile(fullPath)
                } else {
                    let _ = explorer.createDirectory(fullPath)
                }
                // refresh the items
                reloadCell(currentDir)
            }
        }
    }
    
    // MARK: private methods
    
    fileprivate func loadData() {
        // add the "button" at first place for upper directory
        items.insert(File(), at: 0)
        
        currentDir = explorer.documentDir
        let files = explorer.getFileListFromFolder(currentDir)
        for file in files {
            var aFile = File(path: currentDir, name: file)
            aFile.setAttributes()
            items.append(aFile)
        }
    }
    
    fileprivate func reloadCell(_ fullpath: String) {
        // do not go out of the sandbox
        if fullpath == "/var/mobile/Containers/Data/Application" {
            AlertManager.showTips(self, message: LanguageManager.getToolString(forKey: "explorer.upper.error"), handler: nil)
            return
        }
        // do enter the folder
        currentDir = fullpath
        
        // delete the old items
        let n = items.count
        for _ in 1..<n {
            items.remove(at: 1)
            collectionView.deleteItems(at: [IndexPath(row: 1, section: 0)])
        }
        
        // create the new items
        let filelist = explorer.getFileListFromFolder(fullpath)
        if filelist.count > 0 {
            for i in 0..<filelist.count {
                var aFile = File(path: currentDir, name: filelist[i])
                aFile.setAttributes()
                items.insert(aFile, at: i + 1)
                collectionView.insertItems(at: [IndexPath(row: i + 1, section: 0)])
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
    
    fileprivate func setupCell() {
        addSubview(nameLabel)
        addSubview(imageView)
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[v0(64)]-|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": imageView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v1(64)]-[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": nameLabel, "v1": imageView]))
    }
    
    // MARK: getters and setters
    
    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    fileprivate let imageView: UIImageView = {
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
    
    fileprivate func setupComponents() {
        let createBtn = UIButton(type: .system)
        createBtn.frame = CGRect(x: 0, y: 0, width: 90, height: 40)
        createBtn.setTitle(LanguageManager.getToolString(forKey: "explorer.popover.create"), for: UIControlState())
        createBtn.titleLabel?.textAlignment = .center
        createBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        createBtn.addTarget(self, action: #selector(tapCreateBtn), for: .touchUpInside)
        view.addSubview(createBtn)
 
        let pasteBtn = UIButton(type: .system)
        pasteBtn.frame = CGRect(x: 0, y: 40, width: 90, height: 40)
        pasteBtn.setTitle(LanguageManager.getToolString(forKey: "explorer.popover.paste"), for: UIControlState())
        pasteBtn.titleLabel?.textAlignment = .center
        pasteBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        pasteBtn.isEnabled = enablePaste
        pasteBtn.addTarget(self, action: #selector(tapPasteBtn), for: .touchUpInside)
        view.addSubview(pasteBtn)
    }
    
    // MARK: event response
    
    func tapCreateBtn() {
        dismiss(animated: true, completion: {
            self.delegate?.didClickCreateButton()
        })
    }
    
    func tapPasteBtn() {
        dismiss(animated: true, completion: {
            self.delegate?.didClickPasteButton()
        })
    }
}
