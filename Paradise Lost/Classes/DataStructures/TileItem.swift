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
        case none
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
    
    class func mergeAsideFromItems(var items: [TileItem], atDirection direct: Direction) -> Bool {
        switch direct {
        case .none:
            return false
        case .up:
            var i = 0;
            while (i < 12) {
                if (items[i].value == items[i + 4].value) {
                    items[i].value = items[i].value * 2
                    items[i + 4].value = 0
                    var j = i
                    while (j < 12) {
                        if (items[j].value == 0) {
                            items[j].value = items[j + 4].value
                            items[j + 4].value = 0
                        }
                        j = j + 4
                    }
                }
                i = i + 1
            }
            break
        case .down:
            var i = 15;
            while (i > 3) {
                if (items[i].value == items[i - 4].value) {
                    items[i].value = items[i].value * 2
                    items[i - 4].value = 0
                    var j = i
                    while (j > 3) {
                        if (items[j].value == 0) {
                            items[j].value = items[j - 4].value
                            items[j - 4].value = 0
                        }
                        j = j - 4
                    }
                }
                i = i - 1
            }
            break
        case .left:
            var i = 0
            while (i != 3) {
                if (items[i].value == items[i + 1].value) {
                    items[i].value = items[i].value * 2
                    items[i + 1].value = 0;
                    var j = i
                    while (j % 4 < 3) {
                        if (items[j].value == 0) {
                            items[j].value = items[j + 1].value
                            items[j + 1].value = 0
                        }
                        j = j + 1
                    }
                }
                i = (i + 4 > 15) ? (i - 11) : (i + 4)
            }
            break
        case .right:
            var i = 15
            while (i != 12) {
                if (items[i].value == items[i - 1].value) {
                    items[i].value = items[i].value * 2
                    items[i - 1].value = 0;
                    var j = i
                    while (j % 4 > 0) {
                        if (items[j].value == 0) {
                            items[j].value = items[j - 1].value
                            items[j - 1].value = 0
                        }
                        j = j - 1
                    }
                }
                i = (i - 4 < 0) ? (i + 11) : (i - 4)
            }
            break
        }
        return true
    }
}
