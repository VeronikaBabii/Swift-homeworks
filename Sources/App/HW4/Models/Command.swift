//
//  Command.swift
//
//  Created by Veronika Babii on 07.10.2021.
//

import Foundation

struct Command {
    var name: String
    var value: Float
    
    func getArrow() -> String {
        switch name {
        case "forward":
            let length = Length(value: value)
            return "\(Angles.up.arrow)(\(length.distance))"
        case "right": return checkAngle()
        case "left": return checkAngle()
        default: return ""
        }
    }
    
    func checkAngle() -> String {
        switch name {
        case "right":
            switch value {
            case 0: return Angles.up.arrow
            case 90: return Angles.right.arrow
            case 180: return Angles.down.arrow
            case 270: return Angles.left.arrow
            default: return ""
            }
        case "left":
            switch value {
            case 0: return Angles.up.arrow
            case 90: return Angles.left.arrow
            case 180: return Angles.down.arrow
            case 270: return Angles.right.arrow
            default: return ""
            }
        default: return ""
        }
    }
    
    func convertValueToCm() -> Int {
        return Int(value * 100)
    }
}
