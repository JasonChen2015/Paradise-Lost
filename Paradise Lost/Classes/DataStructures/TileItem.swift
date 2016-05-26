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
    
    class func changeValueFromItems(items: [Int], atIndex index: Int, newValue: Int) -> [Int] {
        var temp = items
        temp[index] = newValue
        return temp
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
    
    class func addANewValueToTile(items: [Int]) -> ([Int], Bool) {
        var temp = items
        var hasPos = true
        var s = 0
        // judge if has position to put a new value
        for i in 0..<items.count {
            if items[i] != 0 {
                s = s + 1
            }
        }
        if s == items.count {
            hasPos = false
        }
        // get new value
        let val = Int(arc4random_uniform(10))
        var value = 0
        if val < 9 {
            value = 2
        } else {
            value = 4
        }
        while hasPos {
            // get new position
            let pos = Int(arc4random_uniform(16))
            if temp[pos] == 0 {
                temp[pos] = value
                break
            }
        }
        return (temp, hasPos)
    }
    
    /*
    General Direction is .Left:
        00 01 02 03
        04 05 06 07
        08 09 10 11
        12 13 14 15
    */
    class func rotateTileItemsToGeneral(items: [Int], atDirection direct: Direction) -> [Int] {
        var temp = items
        switch direct {
        case .None:
            break
        case .Up:
            for i in 0..<4 {
                for j in 0..<4 {
                    temp[i + j * 4] = items[i * 4 + 3 - j]
                }
            }
            break
        case .Down:
            for i in 0..<4 {
                for j in 0..<4 {
                    temp[i + j * 4] = items[12 - i * 4 + j]
                }
            }
            break
        case .Left:
            break
        case .Right:
            for i in 0..<4 {
                for j in 0..<4 {
                    temp[i + j * 4] = items[3 - i + j * 4]
                }
            }
            break
        }
        return temp
    }
    
    class func mergeTileItemsToLeft(items: [Int]) -> ([Int], Int, Bool) {
        var temp = items
        var score = 0
        var hasMove = false
        for j in 0..<4 {
            // merge, e.g. [0 2 2 4] -> [0 4 0 4]
            var p = 0
            while (p < 3) {
                if temp[j * 4 + p] == 0 {
                    p = p + 1
                    continue
                }
                var q = p + 1
                while (q < 4 && items[j * 4 + q] == 0) {
                    q = q + 1
                }
                if q < 4 && temp[j * 4 + p] == temp[j * 4 + q] {
                    temp[j * 4 + p] = items[j * 4 + p] + items[j * 4 + q]
                    temp[j * 4 + q] = 0
                    score = score + temp[j * 4 + p]
                    hasMove = true
                    p = q + 1
                } else {
                    p = p + 1
                }
            }
            // place, e.g. [0 4 0 4] -> [4 4 0 0]
            p = 0
            while (p < 3) {
                if temp[j * 4 + p] != 0 {
                    p = p + 1
                    continue
                }
                var q = p + 1
                // find the next none 0
                while (q < 4 && temp[j * 4 + q] == 0) {
                    q = q + 1
                }
                if q < 4 && temp[j * 4 + q] != 0 {
                    temp[j * 4 + p] = temp[j * 4 + q]
                    temp[j * 4 + q] = 0
                    hasMove = true
                    p = p + 1
                } else {
                    break
                }
            }
        }
        return (temp, score, hasMove)
    }
    
    class func mergeAsideFromItems(items: [Int], atDirection direct: Direction) -> ([Int], Int, Bool) {
        var temp  = items
        var score = 0
        var hasMove = false
        switch direct {
        case .None:
            break
        case .Up:
            temp = rotateTileItemsToGeneral(items, atDirection: .Up)
            (temp, score, hasMove) = mergeTileItemsToLeft(temp)
            temp = rotateTileItemsToGeneral(temp, atDirection: .Down)
            break
        case .Down:
            temp = rotateTileItemsToGeneral(items, atDirection: .Down)
            (temp, score, hasMove) = mergeTileItemsToLeft(temp)
            temp = rotateTileItemsToGeneral(temp, atDirection: .Up)
            break
        case .Left:
            (temp, score, hasMove) = mergeTileItemsToLeft(items)
            break
        case .Right:
            temp = rotateTileItemsToGeneral(items, atDirection: .Right)
            (temp, score, hasMove) = mergeTileItemsToLeft(temp)
            temp = rotateTileItemsToGeneral(temp, atDirection: .Right)
            break
        }
        return (temp, score, hasMove)
    }
}
