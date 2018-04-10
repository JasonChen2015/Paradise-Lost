//
//  ImageManager.swift
//  Paradise Lost
//
//  Created by jason on 28/9/2017.
//  Copyright © 2017 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

class ImageManager {
    class func resize(originImage: UIImage?, newWidth: CGFloat, newHeight: CGFloat) -> UIImage? {
        if let origin = originImage {
            return origin
        } else {
            return nil
        }
    }
}
