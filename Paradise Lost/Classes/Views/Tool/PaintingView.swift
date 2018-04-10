//
//  PaintingView.swift
//  Paradise Lost
//
//  Created by jason on 26/9/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import UIKit

protocol PaintingViewDelegate {
    // main view action
    func exit()
    func savePic()
    func getPic()
    // tool action
    func changePenMode()
    func changeResizeMode()
    func changeTextMode()
}

class PaintingView: UIView {
    
    var delegate: PaintingViewDelegate? = nil
    var isBgColorBlack: Bool = true
    
    var hasImage: Bool {
        get {
            return mainImageView.image != nil
        }
    }
    
    enum TouchType: Int {
        case none       = 0
        case upLeft     = 1
        case up         = 2
        case upRight    = 3
        case left       = 4
        case body       = 5
        case right      = 6
        case downLeft   = 7
        case down       = 8
        case downRight  = 9
    }
    
    /// record the touch position
    private var touchType: TouchType = .none
    
    /// the size of original picture
    private var originPicWidth: CGFloat = 0
    private var originPicHeight: CGFloat = 0
    
    /// the size of main image view
    private var imageViewWidth: CGFloat = 400
    private var imageViewHeight: CGFloat = 400
    
    // MARK: life cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black
        isBgColorBlack = true
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        //addSubview(titleLabel)
        addSubview(backButton)
        addSubview(saveButton)
        addSubview(getButton)
        addSubview(mainImageView)
        
        // action
        backButton.addTarget(self, action: #selector(PaintingView.clickBackButton), for: .touchUpInside)
        saveButton.addTarget(self, action: #selector(PaintingView.clickSaveButton), for: .touchUpInside)
        getButton.addTarget(self, action: #selector(PaintingView.clickGetButton), for: .touchUpInside)
        
        let tapView = UITapGestureRecognizer(target: self, action: #selector(PaintingView.changeBackground))
        addGestureRecognizer(tapView)
        
        // interaction of image view
        let singlePanImageView = UIPanGestureRecognizer(target: self, action: #selector(PaintingView.singlePanImageView(_:)))
        mainImageView.addGestureRecognizer(singlePanImageView)
        let doublePanImageView = UIPanGestureRecognizer(target: self, action: #selector(PaintingView.doublePanImageView(_:)))
        doublePanImageView.minimumNumberOfTouches = 2
        mainImageView.addGestureRecognizer(doublePanImageView)
    }
    
    override func layoutSubviews() {
        let buttonWidth = CGFloat(60)
        let buttonPadding = CGFloat(10)
        let marginWidth = self.bounds.width - buttonWidth * 3 - buttonPadding * 3
        
        let viewDict: [String: Any] = ["b0": backButton, "b1": saveButton, "b2": getButton]
        let metricDict = ["bw": buttonWidth, "bp": buttonPadding, "mw": marginWidth]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-bp-[b0(bw)]-mw-[b1(==b0)]-bp-[b2(==b0)]-bp-|", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-bp-[b0]", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-bp-[b1]", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-bp-[b2]", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        // main image view
        addConstraint(NSLayoutConstraint(item: mainImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: imageViewWidth))
        addConstraint(NSLayoutConstraint(item: mainImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: imageViewHeight))
        addConstraint(NSLayoutConstraint(item: mainImageView, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1.0, constant: 0.0))
        addConstraint(NSLayoutConstraint(item: mainImageView, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1.0, constant: 0.0))
    }
    
    // MARK: event response
    
    func clickBackButton() {
        delegate?.exit()
    }
    
    func clickSaveButton() {
        delegate?.savePic()
    }
    
    func clickGetButton() {
        delegate?.getPic()
    }
    
    func changeBackground() {
        if (isBgColorBlack) {
            isBgColorBlack = false
            self.backgroundColor = UIColor.white
            mainImageView.backgroundColor = UIColor.white
            backButton.setTitleColor(UIColor.black, for: UIControlState())
            saveButton.setTitleColor(UIColor.black, for: UIControlState())
            getButton.setTitleColor(UIColor.black, for: UIControlState())
        } else {
            isBgColorBlack = true
            self.backgroundColor = UIColor.black
            mainImageView.backgroundColor = UIColor.black
            backButton.setTitleColor(UIColor.white, for: UIControlState())
            saveButton.setTitleColor(UIColor.white, for: UIControlState())
            getButton.setTitleColor(UIColor.white, for: UIControlState())
        }
        setNeedsDisplay()
    }
    
    // for resize mode
    func singlePanImageView(_ sender: UIPanGestureRecognizer) {
        if (sender.state == .began) {
            let lp = sender.location(in: mainImageView)
            touchType = getTouchType(point: lp)
        } else if (sender.state == .changed) {
            /*
             let px = CGFloat(0), py = CGFloat(0), pw = mainImageView.image?.size.width
             let tp = sender.translation(in: mainImageView)
             var cx, cy, cw, ch: CGFloat
             switch touchType {
             case .upLeft:
             cx = px + tp.x
             cy = py + tp.y
             break
             default:
             break
             }
             */
        }
    }
    
    // for drag picture
    func doublePanImageView(_ sender: UIPanGestureRecognizer) {
    }
    
    func loadImage(rawImage: UIImage?) {
        if let image = rawImage {
            originPicWidth = image.size.width
            originPicHeight = image.size.height
            var newImage = image
            
            if (originPicWidth > imageViewWidth) {
                let scale = imageViewWidth / originPicWidth
                if let resizedImage = ImageManager.resize(originImage: image, newWidth: imageViewWidth, newHeight: originPicHeight * scale) {
                    newImage = resizedImage
                }
            }
            if (originPicHeight > imageViewHeight) {
                let scale = imageViewHeight / originPicHeight
                if let resizedImage = ImageManager.resize(originImage: image, newWidth: originPicWidth * scale, newHeight: imageViewHeight) {
                    newImage = resizedImage
                }
            }
            
            mainImageView.image = newImage
        }
    }
    
    // MARK: private method
    fileprivate func getTouchType(point: CGPoint?) -> TouchType {
        var s = 0 // result
        if let p = point {
            let k = CGFloat(15) // offset
            if (-k <= p.x && p.x < k) { // left
                s = 1
            } else if (k <= p.x && p.x < imageViewWidth - k) { // mid horizon
                s = 2
            } else if (imageViewWidth - k <= p.x && p.x <= imageViewWidth + k) { // right
                s = 3
            }
            if (-k <= p.y && p.y < k) { // top
                s += 0
            } else if (k <= p.y && p.y < imageViewHeight - k) { // mid vertical
                s += 3
            } else if (imageViewHeight - k <= p.y && p.y <= imageViewHeight + k) { // down
                s += 6
            }
        }
        return TouchType(rawValue: s)!
    }
    
    // MARK: getters and setters
    
    func getImage() -> UIImage? {
        // TODO: should return the original size image
        return mainImageView.image
    }
    
    fileprivate var mainImageView: UIImageView = {
        var imageView = UIImageView()
        imageView.backgroundColor = UIColor.black
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    fileprivate var backButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getPublicString(forKey: "return"), for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var saveButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getToolString(forKey: "paint.save.title"), for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    fileprivate var getButton: UIButton = {
        var button = UIButton(type: .system)
        button.setTitle(LanguageManager.getToolString(forKey: "paint.get.title"), for: UIControlState())
        button.setTitleColor(UIColor.white, for: UIControlState())
        button.isExclusiveTouch = true
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
}

class PaintingToolView: UIView {
    
    var delegate: PaintingViewDelegate? = nil
    
    enum Mode {
        case none
        case pen
        case resize
        case text
    }
    
    var currentMode: Mode = .none
    
    // MARK: life cycle
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        addSubview(penImage)
        addSubview(resizeImage)
        addSubview(textImage)
        addSubview(selectView)
        
        selectView.isHidden = true
        
        // action
        
        let penTap = UITapGestureRecognizer(target: self, action: #selector(PaintingToolView.clickPenImage))
        penImage.addGestureRecognizer(penTap)
        let resizeTap = UITapGestureRecognizer(target: self, action: #selector(PaintingToolView.clickResizeImage))
        resizeImage.addGestureRecognizer(resizeTap)
        let textTap = UITapGestureRecognizer(target: self, action: #selector(PaintingToolView.clickTextImage))
        textImage.addGestureRecognizer(textTap)
    }
    
    override func layoutSubviews() {
        let imagePadding = CGFloat(15)
        let imageHeight = self.bounds.height - imagePadding * 2
        let selectHeight = imageHeight + 7
        
        let viewDict: [String: Any] = ["i0": penImage, "i1": resizeImage, "i2": textImage, "v0": selectView]
        let metricDict = ["ih": imageHeight, "pad": imagePadding, "sh": selectHeight]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-pad-[i0(ih)]-20-[i1(ih)]-20-[i2(ih)]", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-pad-[i0(ih)]-pad-|", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-pad-[i1(ih)]-pad-|", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-pad-[i2(ih)]-pad-|", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[v0(sh)]", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(sh)]", options: NSLayoutFormatOptions(), metrics: metricDict, views: viewDict))
        addConstraint(NSLayoutConstraint(item: selectView, attribute: .centerX, relatedBy: .equal, toItem: penImage, attribute: .centerX, multiplier: 1.0, constant: 0.0))
    }
    
    // MARK: event response
    
    func clickPenImage() {
        if (currentMode == .pen) {
            selectView.isHidden = true
            currentMode = .none
        } else {
            selectView.isHidden = false
            selectView.center = penImage.center
            currentMode = .pen
        }
        setNeedsDisplay()
        delegate?.changePenMode()
    }
    
    func clickResizeImage() {
        if (currentMode == .resize) {
            selectView.isHidden = true
            currentMode = .none
        } else {
            selectView.isHidden = false
            selectView.center = resizeImage.center
            currentMode = .resize
        }
        setNeedsDisplay()
        delegate?.changeResizeMode()
    }
    
    func clickTextImage() {
        if (currentMode == .text) {
            selectView.isHidden = true
            currentMode = .none
        } else {
            selectView.isHidden = false
            selectView.center = textImage.center
            currentMode = .text
        }
        setNeedsDisplay()
        delegate?.changeTextMode()
    }
    
    // MARK: getters and setters
    
    fileprivate var penImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "pen")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var resizeImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "resize")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var textImage: UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named: "text")
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    fileprivate var selectView: PaintingSelectView = {
        var view = PaintingSelectView()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        view.isUserInteractionEnabled = false
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    fileprivate var textView: UITextView = {
        var view = UITextView()
        return view
    }()
}

class PaintingColorView: UIScrollView {
    
    let colorArrray: [UIColor] = [UIColor.red, UIColor.green, UIColor.blue, UIColor.black, UIColor.white]
    
    // MARK: life cycle
    
    override init(frame:CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Color().FrechBeige
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    fileprivate func setupView() {
        let length = 30
        let spacing = 5
        var xPos = spacing
        for i in colorArrray {
            let v = UIView(frame: CGRect(x: xPos, y: spacing, width: length, height: length))
            v.backgroundColor = i
            addSubview(v)
            //
            xPos += length + spacing
        }
        isUserInteractionEnabled = true
        contentSize = CGSize(width: xPos, height: length)
    }
    
    // MARK: getters and setters
}

class PaintingSelectView: UIView {
    override func draw(_ rect: CGRect) {
        let height = rect.height
        let width = rect.width
        
        let gridPath = UIBezierPath()
        gridPath.lineWidth = 3
        
        gridPath.move(to: CGPoint(x: 0, y: 0))
        gridPath.addLine(to: CGPoint(x: width, y: 0))
        gridPath.move(to: CGPoint(x: width, y: 0))
        gridPath.addLine(to: CGPoint(x: width, y: height))
        gridPath.move(to: CGPoint(x: 0, y: 0))
        gridPath.addLine(to: CGPoint(x: 0, y: height))
        gridPath.move(to: CGPoint(x: 0, y: height))
        gridPath.addLine(to: CGPoint(x: width, y: height))
        
        UIColor.red.setStroke()
        gridPath.stroke()
    }
}
