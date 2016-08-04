//
//  FileExplorerVC.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/13/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import UIKit

class FileExplorerVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let cellReuseIdentifier: String = "CollectionViewCell"
    var collectionView: UICollectionView!
    
    /// restore the cells
    var items: [File] = []
    /// file explorer manager
    var explorer = FileExplorerManager() {
        didSet {
            if explorer.documentDir == "" {
                AlertManager.showTips(self, message: "Can not initialize File Explorer.", handler: { (_) -> Void in
                    self.dismissViewControllerAnimated(true, completion: nil)
                    return
                })
            }
        }
    }
    /// record the current directory of absolute path
    var currentDir = ""
    
    // MARK: life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadDate()
        
        // set up collection view
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 80, height: 90)
        flowLayout.sectionInset = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        
        collectionView = UICollectionView(frame: UIScreen.mainScreen().bounds, collectionViewLayout: flowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.registerClass(FileCollectionViewCell.self, forCellWithReuseIdentifier: cellReuseIdentifier)
        
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
                break
            }
            // set name
            aCell.nameLabel.text = file.getFileName()
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
            //TODO: enter folder
            reloadCell(fullpath)
            break
        case .File:
            //TODO: show info of the file
            break
        default:
            break
        }
    }
    
    // MARK: event response
    
    func goToUpperDirectory() {
        if let upperURL = NSURL(fileURLWithPath: currentDir).URLByDeletingLastPathComponent {
            reloadCell(upperURL.relativePath!)
        } else {
            // TODO: alert that can not go to the upper directory
            AlertManager.showTips(self, message: "Can't go to the upper directory.", handler: nil)
        }
    }
    
    // MARK: private methods
    
    private func loadDate() {
        // add the "button" at first place for upper directory
        items.insert(File(), atIndex: 0)
        
        currentDir = explorer.documentDir
        let files = explorer.getFileListFromFolder(currentDir)
        for file in files {
            let aFile = File(filePath: currentDir, fileName: file)
            items.append(aFile)
        }
    }
    
    private func reloadCell(fullpath: String) {
        // do not go out of the sandbox
        if fullpath == "/var/mobile/Containers/Data/Application" {
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
                items.insert(File(filePath: currentDir, fileName: filelist[i]), atIndex: i + 1)
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