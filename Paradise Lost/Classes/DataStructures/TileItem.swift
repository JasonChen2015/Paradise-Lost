//
//  TileItem.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/17/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

struct TileItem {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}

class TileItemManager {
    /*
    00 01 02 03
    04 05 06 07
    08 09 10 11
    12 13 14 15
    */
    
    enum Direction {
        case up
        case down
        case left
        case right
    }
    
    class func changeValueFromItems(var items: [TileItem], atIndex index: Int, newValue: Int) {
        items[index].value = newValue
    }
    
    class func getValueFromItems(items: [TileItem], atIndex index: Int) -> Int {
        return items[index].value
    }
    
    class func hasValueFromItems(items: [TileItem], atIndex index: Int) -> Bool {
        if getValueFromItems(items, atIndex: index) == 0 {
            return false
        } else {
            return true
        }
    }
    
    class func mergeAsideFromItems(items: [TileItem], atIndex index: Int, atDirection direct: Direction) -> Bool {
        // TODO:
        switch direct {
        case .up:
            if index < 4 {
                return false
            }
            break
        case .down:
            break
        case .left:
            break
        case .right:
            break
        }
        return false
    }
}
