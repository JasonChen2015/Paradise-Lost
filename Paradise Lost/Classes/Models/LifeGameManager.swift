//
//  LifeGameManager.swift
//  Paradise Lost
//
//  Created by jason on 29/9/2016.
//  Copyright © 2016 Jason Chen. All rights reserved.
//

import Foundation

class LifeGameManager {
    // 0 for no 1 for have
    fileprivate var status: [[Int]] = Array(repeating: Array(repeating: 0, count: 500), count: 500)
    var row: Int!
    var column: Int!
    
    func getStatus() -> [[Int]] {
        return status
    }
    
    func getEditable(_ x: Int, y: Int, rows: Int, columns: Int) -> [[Int]] {
        var temp = Array(repeating: Array(repeating: 0, count: 500), count: 500)
        let tx = x < 1 ? 0 : (x - 1)
        let ty = y < 1 ? 0 : (y - 1)
        for i in 0...(columns - 1) {
            if i + tx >= column { break}
            for j in 0...(rows -  1) {
                if j + ty >= row { break}
                temp[i][j] = status[i + tx][j + ty]
            }
        }
        return temp
    }
    
    func setEditable(_ x: Int, y: Int, rows: Int, columns: Int, array: [[Int]]) {
        let tx = x < 1 ? 0 : (x - 1)
        let ty = y < 1 ? 0 : (y - 1)
        for i in 0...(columns - 1) {
            if i + tx >= column { break}
            for j in 0...(rows -  1) {
                if j + ty >= row { break}
                status[i + tx][j + ty] = array[i][j]
            }
        }
    }
    
    func generate() {
        var temp = status
        for i in 0...column {
            for j in 0...row {
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
    
    func surroundCount(x: Int, y: Int) -> Int {
        var count = 0
        if x > 0 {
            if y > 0 && status[x - 1][y - 1] == 1 {
                count = count + 1
            }
            if status[x - 1][y] == 1 { count = count + 1 }
            if y < row && status[x - 1][y + 1] == 1 {
                count = count + 1
            }
        }
        if y > 0 && status[x][y - 1] == 1 {
            count = count + 1
        }
        if y < row && status[x][y + 1] == 1 {
            count = count + 1
        }
        if x < column {
            if y > 0 && status[x + 1][y - 1] == 1 {
                count = count + 1
            }
            if status[x + 1][y] == 1 { count = count + 1 }
            if y < row && status[x + 1][y + 1] == 1 {
                count = count + 1
            }
        }
        
        return count
    }
    
    func clearStatus() {
        for i in 0...column {
            for j in 0...row {
                status[i][j] = 0
            }
        }
    }
    
    func setPopulate(_ x: Int, _ y: Int) {
        if 0 <= x && x <= column && 0 <= y && y <= row {
            status[x][y] = 1
        }
    }
    
    enum LifeGameGridStyle {
        case glider
        case gliderGun
        case tumbler
        case pulsar
        
        var value: String {
            switch self {
            case .glider:
                return "Glider"
            case .gliderGun:
                return "Gosper Glider Gun"
            case .tumbler:
                return "Tumbler"
            case .pulsar:
                return "Pulsar"
            }
        }
    }
    
    static let style = ["Glider", "Gosper Glider Gun", "Tumbler", "Pulsar"]
    
    func getLiftGameGridStyleFromIndex(_ index: Int) -> LifeGameGridStyle {
        switch index {
        case 0: return .glider
        case 1: return .gliderGun
        case 2: return .tumbler
        case 3: return .pulsar
        default: return .glider
        }
    }
    
    func addStyle(_ style: LifeGameGridStyle, x: Int, y: Int, axes: LifeGameAxes = .origin, mirror: Bool = false) {
        switch style {
        case .glider:
            addGliderAtPoint(x: x, y: y, axes: axes, mirror: mirror)
            break
        case .gliderGun:
            addGliderGunAtPoint(x: x, y: y, axes: axes)
            break
        case .tumbler:
            addTumblerAtPoint(x: x, y: y, axes: axes, mirror: mirror)
            break
        case .pulsar:
            addPulsarAtPoint(x: x, y: y, axes: axes, mirror: mirror)
            break
        }
    }
    
    enum LifeGameAxes {
        case origin   // mirror: mirror x=y
        case mirrorY  // mirror t axes, mirror: rotate anticlockwise 90 degree
        case mirrorX  // mirror x axes, mirror: rotate clockwise 90
        case mirrorXY // rotate 180 degree, mirror:
        
        var value: (Int, Int) {
            switch self {
            case .origin:
                return (1, 1)
            case .mirrorY:
                return (-1, 1)
            case .mirrorX:
                return (1, -1)
            case .mirrorXY:
                return (-1, -1)
            }
        }
    }
    /*
     [0, 0, 1]
     [1, 0, 1]
     [0, 1, 1]
     */
    func addGliderAtPoint(x: Int, y: Int, axes: LifeGameAxes = .origin, mirror: Bool = false) {
        let (xe, ye) = axes.value
        if !mirror {
            setPopulate(x + 2 * xe, y)
            setPopulate(x, y + ye)
        } else {
            setPopulate(x, y + 2 * ye)
            setPopulate(x + xe, y)
        }
        setPopulate(x + 2 * xe, y + ye)
        setPopulate(x + xe, y + 2 * ye)
        setPopulate(x + 2 * xe, y + 2 * ye)
    }
    
    /*
     [1, 1]
     [1, 1]
     */
    func addBlockAtPoint(x: Int, y: Int, axes: LifeGameAxes = .origin, mirror: Bool = false) {
        let (xe, ye) = axes.value
        setPopulate(x, y)
        setPopulate(x + xe, y)
        setPopulate(x, y + ye)
        setPopulate(x + xe, y + ye)
    }
    
    /*
     [0, 1, 1]
     [1, 0, 1]
     [1, 1, 0]
     */
    func addShipAtPoint(x: Int, y: Int, axes: LifeGameAxes = .origin, mirror: Bool = false) {
        let (xe, ye) = axes.value
        setPopulate(x + xe, y)
        setPopulate(x + 2 * xe, y)
        setPopulate(x, y + ye)
        setPopulate(x + 2 * xe, y + ye)
        setPopulate(x, y + 2 * ye)
        setPopulate(x + xe, y + 2 * ye)
    }
    
    func addGliderGunAtPoint(x: Int, y: Int, axes: LifeGameAxes = .origin) {
        let (xe, ye) = axes.value
        addBlockAtPoint(x: x, y: y)
        addShipAtPoint(x: x + 8 * xe, y: y)
        addGliderAtPoint(x: x + 18 * xe, y: y + 4 * ye, axes: .mirrorXY)
        addShipAtPoint(x: x + 22 * xe, y: y - 2 * ye)
        addGliderAtPoint(x: x + 26 * xe, y: y + 12 * ye, axes: .mirrorXY, mirror: true)
        addBlockAtPoint(x: x + 34 * xe, y: y - 2 * ye)
        addGliderAtPoint(x: x + 37 * xe, y: y + 7 * ye, axes: .mirrorXY)
    }
    
    /*
     [1, 0, 1, 0, 1]
     [1, 0, 0, 0, 1]
     [1, 0, 0, 0, 1]
     [1, 0, 0, 0, 1]
     [1, 0, 1, 0, 1]
     */
    func addPulsarAtPoint(x: Int, y: Int, axes: LifeGameAxes = .origin, mirror: Bool = false) {
        let (xe, ye) = axes.value
        if !mirror {
            setPopulate(x, y + ye)
            setPopulate(x + 4 * xe, y + ye)
            setPopulate(x, y + 3 * ye)
            setPopulate(x + 4 * xe, y + 3 * ye)
        } else {
            setPopulate(x + xe, y)
            setPopulate(x + xe, y + 4 * ye)
            setPopulate(x + 3 * xe, y)
            setPopulate(x + 3 * xe, y + 4 * ye)
        }
        setPopulate(x, y)
        setPopulate(x + 2 * xe, y)
        setPopulate(x + 4 * xe, y)
        setPopulate(x, y + 2 * ye)
        setPopulate(x, y + 4 * ye)
        setPopulate(x + 2 * xe, y + 4 * ye)
        setPopulate(x + 4 * xe, y + 2 * ye)
        setPopulate(x + 4 * xe, y + 4 * ye)
    }
    /*
     [1, 0, 0, 0, 0, 0, 1]
     [0, 1, 1, 0, 1, 1, 0]
     [0, 0, 1, 0, 1, 0, 0]
     [1, 0, 0, 0, 0, 0, 1]
     [1, 1, 1, 0, 1, 1, 1]
     */
    func addTumblerAtPoint(x: Int, y: Int, axes: LifeGameAxes = .origin, mirror: Bool = false) {
        let (xe, ye) = axes.value
        if !mirror {
            setPopulate(x + 6 * xe, y)
            setPopulate(x + 2 * xe, y + ye)
            setPopulate(x + 5 * xe, y + ye)
            setPopulate(x, y + 3 * ye)
            setPopulate(x + 6 * xe, y + 3 * ye)
            setPopulate(x, y + 4 * ye)
            setPopulate(x + 5 * xe, y + 4 * ye)
            setPopulate(x + 6 * xe, y + 4 * ye)
        } else {
            setPopulate(x, y + 6 * ye)
            setPopulate(x + xe, y + 2 * ye)
            setPopulate(x + xe, y + 5 * ye)
            setPopulate(x + 3 * xe, y)
            setPopulate(x + 3 * xe, y + 6 * ye)
            setPopulate(x + 4 * xe, y)
            setPopulate(x + 4 * xe, y + 5 * ye)
            setPopulate(x + 4 * xe, y + 6 * ye)
        }
        setPopulate(x, y)
        setPopulate(x + xe, y + ye)
        setPopulate(x + 2 * xe, y + 2 * ye)
        setPopulate(x + 4 * xe, y + ye)
        setPopulate(x + xe, y + 4 * ye)
        setPopulate(x + 4 * xe, y + 2 * ye)
        setPopulate(x + 2 * xe, y + 4 * ye)
        setPopulate(x + 4 * xe, y + 4 * ye)
    }
}
