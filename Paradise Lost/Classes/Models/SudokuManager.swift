//
//  SudokuManager.swift
//  Paradise Lost
//
//  Created by Jason Chen on 6/1/16.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class SudokuManager {
    class func checkCorrect(items: [Int]) -> Bool {
        // check zero
        for i in 0..<9 {
            for j in 0..<9 {
                if items[i + j * 9] == 0 {
                    return false
                }
            }
        }
        
        // horizontal line
        for j in 0..<9 {
            var check = 0x1FF
            for i in 0..<9 {
                check = (1 << (items[i + j * 9] - 1)) ^ check
            }
            if check != 0 {
                return false
            }
        }
        
        // vertical line
        for i in 0..<9 {
            var check = 0x1FF
            for j in 0..<9 {
                check = (1 << (items[i + j * 9] - 1)) ^ check
            }
            if check != 0 {
                return false
            }
        }
        
        // region
        for i in 0..<3 {
            for j in 0..<3 {
                let leftUp = i * 27 + j * 3 // the index of left-up in a region
                var check = 0x1FF
                for k in 0..<3 {
                    for l in 0..<3 {
                        check = (1 << (items[leftUp + k * 9 + l] - 1)) ^ check
                    }
                }
                if check != 0 {
                    return false
                }
            }
        }
        
        return true
    }
    
    /*
        count out the total number of zero in sudoku
    */
    class func getZeroNumber(items: [Int]) -> Int {
        var sum = 0
        for j in 0..<9 {
            for i in 0..<9 {
                if items[i + j * 9] == 0 {
                    sum = sum + 1
                }
            }
        }
        return sum
    }
    
    class func putNumber(items: [Int], index: Int, number: Int) -> [Int] {
        var temp = items
        temp[index] = number
        return temp
    }
    
    class func getStringFromSudoku(items: [Int]) -> String {
        var temp: String = ""
        for i in 0..<items.count {
            temp = temp + "\(items[i])"
        }
        return temp
    }
    
    class func getSudokuFromString(str: String) -> ([Int], Bool) {
        var zero: [Int] = []
        for _ in 0..<81 {
            zero.append(0)
        }
        var success = true
        
        var temp: [Int] = []
        if str.characters.count != 81 {
            // the str is not in right format thus return a 0 array
            temp = zero
            success = false
        } else {
            for char in str.characters {
                // check each character is in 0..9
                if "0" <= String(char) && String(char) <= "9" {
                    temp.append(Int(String(char))!)
                } else {
                    temp = zero
                    success = false
                    break
                }
            }
        }
        return (temp, success)
    }
    
    class func getSudokuFromDictionary(dict: NSDictionary, atIndex index: Int) -> ([Int], Bool) {
        if let str = dict.objectForKey("\(index)") {
            return getSudokuFromString(str as! String)
        } else {
            return ([], false)
        }
    }
}
