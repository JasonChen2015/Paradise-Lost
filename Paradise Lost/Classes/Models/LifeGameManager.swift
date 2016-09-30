//
//  LifeGameManager.swift
//  Paradise Lost
//
//  Created by jason on 29/9/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class LifeGameManager {
    static let style = ["Glider", "Gosper Glider Gun", "Tumbler", "Pulsar"]
    
    private var status: [[Int]] = Array(count: 500, repeatedValue: Array(count: 500, repeatedValue: 0))
    var height: Int!
    var width: Int!
    
    func getStatus() -> [[Int]] {
        return status
    }
    
    func generate() {
        var temp = status
        for i in 0...width {
            for j in 0...height {
                let count = surroundCount(x: i, y: j)
                if status[i][j] == 1 { // if populated
                    if count < 2 {
                        temp[i][j] = 0 // solitude
                    } else if count > 3 {
                        temp[i][j] = 0 // overpopulation
                    }
                } else { //
                    if count == 3 {
                        temp[i][j] = 1 // born
                    }
                }
            }
        }
        status = temp
    }
    
    func surroundCount(x x: Int, y: Int) -> Int {
        var count = 0
        if x > 0 {
            if y > 0 && status[x - 1][y - 1] == 1 {
                count = count + 1
            }
            if status[x - 1][y] == 1 { count = count + 1 }
            if y < height && status[x - 1][y + 1] == 1 {
                count = count + 1
            }
        }
        if y > 0 && status[x][y - 1] == 1 {
            count = count + 1
        }
        if y < height && status[x][y + 1] == 1 {
            count = count + 1
        }
        if x < width {
            if y > 0 && status[x + 1][y - 1] == 1 {
                count = count + 1
            }
            if status[x + 1][y] == 1 { count = count + 1 }
            if y < height && status[x + 1][y + 1] == 1 {
                count = count + 1
            }
        }
        
        return count
    }
    
    func clearStatus() {
        for i in 0...width {
            for j in 0...height {
                status[i][j] = 0
            }
        }
    }
    
    func setPopulate(x: Int, _ y: Int) {
        if 0 <= x && x <= width && 0 <= y && y <= height {
            status[x][y] = 1
        }
    }
    
    enum LifeGameAxes {
        case First
        case Second
        case Third
        case Fourth
        
        var value: (Int, Int) {
            switch self {
            case .First:
                return (1, 1)
            case .Second:
                return (-1, 1)
            case .Third:
                return (1, -1)
            case .Fourth:
                return (-1, -1)
            }
        }
    }
    
    func addGliderAtPoint(x x: Int, y: Int, axes: LifeGameAxes) {
        let (xe, ye) = axes.value
        setPopulate(x, y)
        setPopulate(x, y + ye)
        setPopulate(x, y + 2 * ye)
        setPopulate(x - xe, y + 2 * ye)
        setPopulate(x - 2 * xe, y + ye)
    }
}