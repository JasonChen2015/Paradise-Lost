//
//  Color.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/17/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
import UIKit

struct Color {
    // refer: https://en.wikipedia.org/wiki/Beige
    var FrechBeige = UIColor(hex: 0xa67b5b)
    var CosmicLatte = UIColor(hex: 0xfff8e7)
    
    // japanese tradictional color
    var Kokiake = UIColor(hex: 0x7b3b3a)
    var Kurotobi = UIColor(hex: 0x351e1c)
    var Kakitsubata = UIColor(hex: 0x491e3c)
    
    // refer: https://github.com/gabrielecirulli/2048 (under License MIT)
    // for 2048 tile color
    var TileBackground = UIColor(hex: 0x8F7a66)
    var TileColor = UIColor(hex: 0xeee4da)
    var TileGoldColor = UIColor(hex: 0xedc22e)
    var DarkGrayishOrange = UIColor(hex: 0x776e65) // dark text color
    var LightGrayishOrange = UIColor(hex: 0xf9f6f2) // light text color
    // for 2048 special tile color
    var BrightOrange = UIColor(hex: 0xf78e48) // 8
    var BrightRed = UIColor(hex: 0xfc5e2e) // 16
    var VividRed = UIColor(hex: 0xff3333) // 32
    var PureRed = UIColor(hex: 0xff0000) // 64
    
    func mixColorBetween(colorA: UIColor, weightA: CGFloat = 0.5, colorB: UIColor, weightB: CGFloat = 0.5) -> UIColor {
        let c1 = colorA.RGBComponents
        let c2 = colorB.RGBComponents
        
        let red = c1.red * weightA + c2.red * weightB
        let green = c1.green * weightA + c2.green * weightB
        let blue = c1.blue * weightA + c2.blue * weightB
        let alpha = c1.alpha * weightA + c2.alpha * weightB
        
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension UIColor {
    var RGBComponents:(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        var r: CGFloat = 0
        var g: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        return (r, g, b, a)
    }
    
    // refer: https://github.com/yannickl/DynamicColor (under License MIT)
    // create a color from hex number (e.g. UIColor(hex: 0xaabbcc))
    convenience init(hex: UInt32) {
        let mask = 0x000000FF
        let r = Int(hex >> 16) & mask
        let g = Int(hex >> 8) & mask
        let b = Int(hex >> 0) & mask
        
        let red = CGFloat(r) / 255
        let green = CGFloat(g) / 255
        let blue = CGFloat(b) / 255
        
        self.init(red: red, green: green, blue: blue, alpha: 1)
    }
}
