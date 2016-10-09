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
    private var status: [[Int]] = Array(count: 500, repeatedValue: Array(count: 500, repeatedValue: 0))
    var row: Int!
    var column: Int!
    
    func getStatus() -> [[Int]] {
        return status
    }
    
    func getEditable(x: Int, y: Int, rows: Int, columns: Int) -> [[Int]] {
        var temp = Array(count: 500, repeatedValue: Array(count: 500, repeatedValue: 0))
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
    
    func setEditable(x: Int, y: Int, rows: Int, columns: Int, array: [[Int]]) {
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
    
    func surroundCount(x x: Int, y: Int) -> Int {
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
    
    func setPopulate(x: Int, _ y: Int) {
        if 0 <= x && x <= column && 0 <= y && y <= row {
            status[x][y] = 1
        }
    }
    
    enum LifeGameGridStyle {
        case Glider
        case GliderGun
        case Tumbler
        case Pulsar
        
        var value: String {
            switch self {
            case .Glider:
                return "Glider"
            case .GliderGun:
                return "Gosper Glider Gun"
            case .Tumbler:
                return "Tumbler"
            case .Pulsar:
                return "Pulsar"
            }
        }
    }
    
    static let style = ["Glider", "Gosper Glider Gun", "Tumbler", "Pulsar"]
    
    func getLiftGameGridStyleFromIndex(index: Int) -> LifeGameGridStyle {
        switch index {
        case 0: return .Glider
        case 1: return .GliderGun
        case 2: return .Tumbler
        case 3: return .Pulsar
        default: return .Glider
        }
    }
    
    func addStyle(style: LifeGameGridStyle, x: Int, y: Int, axes: LifeGameAxes = .Origin, mirror: Bool = false) {
        switch style {
        case .Glider:
            addGliderAtPoint(x: x, y: y, axes: axes, mirror: mirror)
            break
        case .GliderGun:
            addGliderGunAtPoint(x: x, y: y, axes: axes)
            break
        case .Tumbler:
            addTumblerAtPoint(x: x, y: y, axes: axes, mirror: mirror)
            break
        case .Pulsar:
            addPulsarAtPoint(x: x, y: y, axes: axes, mirror: mirror)
            break
        }
    }
    
    enum LifeGameAxes {
        case Origin   // mirror: mirror x=y
        case MirrorY  // mirror t axes, mirror: rotate anticlockwise 90 degree
        case MirrorX  // mirror x axes, mirror: rotate clockwise 90
        case MirrorXY // rotate 180 degree, mirror:
        
        var value: (Int, Int) {
            switch self {
            case .Origin:
                return (1, 1)
            case .MirrorY:
                return (-1, 1)
            case .MirrorX:
                return (1, -1)
            case .MirrorXY:
                return (-1, -1)
            }
        }
    }
    /*
     [0, 0, 1]
     [1, 0, 1]
     [0, 1, 1]
     */
    func addGliderAtPoint(x x: Int, y: Int, axes: LifeGameAxes = .Origin, mirror: Bool = false) {
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
    func addBlockAtPoint(x x: Int, y: Int, axes: LifeGameAxes = .Origin, mirror: Bool = false) {
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
    func addShipAtPoint(x x: Int, y: Int, axes: LifeGameAxes = .Origin, mirror: Bool = false) {
        let (xe, ye) = axes.value
        setPopulate(x + xe, y)
        setPopulate(x + 2 * xe, y)
        setPopulate(x, y + ye)
        setPopulate(x + 2 * xe, y + ye)
        setPopulate(x, y + 2 * ye)
        setPopulate(x + xe, y + 2 * ye)
    }
    
    func addGliderGunAtPoint(x x: Int, y: Int, axes: LifeGameAxes = .Origin) {
        let (xe, ye) = axes.value
        addBlockAtPoint(x: x, y: y)
        addShipAtPoint(x: x + 8 * xe, y: y)
        addGliderAtPoint(x: x + 18 * xe, y: y + 4 * ye, axes: .MirrorXY)
        addShipAtPoint(x: x + 22 * xe, y: y - 2 * ye)
        addGliderAtPoint(x: x + 26 * xe, y: y + 12 * ye, axes: .MirrorXY, mirror: true)
        addBlockAtPoint(x: x + 34 * xe, y: y - 2 * ye)
        addGliderAtPoint(x: x + 37 * xe, y: y + 7 * ye, axes: .MirrorXY)
    }
    
    /*
     [1, 0, 1, 0, 1]
     [1, 0, 0, 0, 1]
     [1, 0, 0, 0, 1]
     [1, 0, 0, 0, 1]
     [1, 0, 1, 0, 1]
     */
    func addPulsarAtPoint(x x: Int, y: Int, axes: LifeGameAxes = .Origin, mirror: Bool = false) {
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
    func addTumblerAtPoint(x x: Int, y: Int, axes: LifeGameAxes = .Origin, mirror: Bool = false) {
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