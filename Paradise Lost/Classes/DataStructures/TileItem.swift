//
//  TileItem.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/17/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation
/*
struct TileItem {
    var value: Int
    
    init(value: Int) {
        self.value = value
    }
}
*/
class TileItemManager {
    /*
    00 01 02 03
    04 05 06 07
    08 09 10 11
    12 13 14 15
    */
    
    enum Direction {
        case None
        case Up
        case Down
        case Left
        case Right
    }
    
    class func generateTileArray(rawData: [Int]) -> [Int] {
        var items: [Int] = [];
        for i in 0..<rawData.count {
            items.insert(rawData[i], atIndex: i)
        }
        return items
    }
    
    class func changeValueFromItems(var items: [Int], atIndex index: Int, newValue: Int) {
        items[index] = newValue
    }
    
    class func getValueFromItems(items: [Int], atIndex index: Int) -> Int {
        return items[index]
    }
    
    class func hasValueFromItems(items: [Int], atIndex index: Int) -> Bool {
        if getValueFromItems(items, atIndex: index) == 0 {
            return false
        } else {
            return true
        }
    }
    
    class func mergeAsideFromItems(var items: [Int], atDirection direct: Direction) -> Bool {
        // TODO: the logic and result of merging is wrong
        switch direct {
        case .None:
            return false
        case .Up:
            var i = 0;
            while (i < 12) {
                if (items[i] == items[i + 4]) {
                    items[i] = items[i] * 2
                    items[i + 4] = 0
                    var j = i
                    while (j < 12) {
                        if (items[j] == 0) {
                            items[j] = items[j + 4]
                            items[j + 4] = 0
                        }
                        j = j + 4
                    }
                }
                i = i + 1
            }
            break
        case .Down:
            var i = 15;
            while (i > 3) {
                if (items[i] == items[i - 4]) {
                    items[i] = items[i] * 2
                    items[i - 4] = 0
                    var j = i
                    while (j > 3) {
                        if (items[j] == 0) {
                            items[j] = items[j - 4]
                            items[j - 4] = 0
                        }
                        j = j - 4
                    }
                }
                i = i - 1
            }
            break
        case .Left:
            var i = 0
            while (i != 3) {
                if (items[i] == items[i + 1]) {
                    items[i] = items[i] * 2
                    items[i + 1] = 0;
                    var j = i
                    while (j % 4 < 3) {
                        if (items[j] == 0) {
                            items[j] = items[j + 1]
                            items[j + 1] = 0
                        }
                        j = j + 1
                    }
                }
                i = (i + 4 > 15) ? (i - 11) : (i + 4)
            }
            break
        case .Right:
            var i = 15
            while (i != 12) {
                if (items[i] == items[i - 1]) {
                    items[i] = items[i] * 2
                    items[i - 1] = 0;
                    var j = i
                    while (j % 4 > 0) {
                        if (items[j] == 0) {
                            items[j] = items[j - 1]
                            items[j - 1] = 0
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
