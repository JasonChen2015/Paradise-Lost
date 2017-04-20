//
//  TZFEManager.swift
//  Paradise Lost
//
//  Created by Jason Chen on 5/17/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class TZFEManager {
    
    enum Direction {
        case none
        case up
        case down
        case left
        case right
    }
    
    class func addANewValueToTile(_ items: [Int]) -> [Int] {
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
            return temp
        }
        // get new value
        let val = Int(arc4random_uniform(10))
        var value = 0
        if val < 9 {
            value = 2 // 90%
        } else {
            value = 4 // 10%
        }
        while hasPos {
            // get new position
            let pos = Int(arc4random_uniform(16))
            if temp[pos] == 0 {
                temp[pos] = value
                break
            }
        }
        return temp
    }
    
    class func hasMoveOnTiles(_ items: [Int]) -> Bool {
        var s = 0
        // judge if has position to put a new value
        for i in 0..<items.count {
            if items[i] != 0 {
                s = s + 1
            }
        }
        if s != items.count {
            return true
        }
        // judge if can merge
        for i in 0..<16 {
            // Up (Down)
            if i > 3 {
                if items[i] == items[i - 4] {
                    return true
                }
            }
            // Left (Right)
            if i % 4 != 0 {
                if items[i] == items[i - 1] {
                    return true
                }
            }
        }
        return false
    }
    
    /*
    General Direction is .Left:
        00 01 02 03
        04 05 06 07     (<-)
        08 09 10 11
        12 13 14 15
    */
    fileprivate class func rotateTileItemsToGeneral(_ items: [Int], fromDirection direct: Direction) -> [Int] {
        var temp = items
        switch direct {
        case .none:
            break
        case .up:
            for i in 0..<4 {
                for j in 0..<4 {
                    temp[i + j * 4] = items[i * 4 + 3 - j]
                }
            }
            break
        case .down:
            for i in 0..<4 {
                for j in 0..<4 {
                    temp[i + j * 4] = items[12 - i * 4 + j]
                }
            }
            break
        case .left:
            break
        case .right:
            for i in 0..<4 {
                for j in 0..<4 {
                    temp[i + j * 4] = items[3 - i + j * 4]
                }
            }
            break
        }
        return temp
    }
    
    fileprivate class func mergeTileItemsToLeft(_ items: [Int]) -> ([Int], Int, Bool) {
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
    
    class func mergeAsideFromItems(_ items: [Int], atDirection direct: Direction) -> ([Int], Int, Bool) {
        var temp  = items
        var score = 0
        var hasMove = false
        switch direct {
        case .none:
            break
        case .up:
            temp = rotateTileItemsToGeneral(items, fromDirection: .up)
            (temp, score, hasMove) = mergeTileItemsToLeft(temp)
            temp = rotateTileItemsToGeneral(temp, fromDirection: .down)
            break
        case .down:
            temp = rotateTileItemsToGeneral(items, fromDirection: .down)
            (temp, score, hasMove) = mergeTileItemsToLeft(temp)
            temp = rotateTileItemsToGeneral(temp, fromDirection: .up)
            break
        case .left:
            (temp, score, hasMove) = mergeTileItemsToLeft(items)
            break
        case .right:
            temp = rotateTileItemsToGeneral(items, fromDirection: .right)
            (temp, score, hasMove) = mergeTileItemsToLeft(temp)
            temp = rotateTileItemsToGeneral(temp, fromDirection: .right)
            break
        }
        return (temp, score, hasMove)
    }
}
