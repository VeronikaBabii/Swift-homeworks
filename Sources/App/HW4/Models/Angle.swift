//
//  Angle.swift
//  
//
//  Created by Veronika Babii on 27.03.2022.
//

import Foundation

struct Angle: Equatable {
    var arrow: String
    
    var symmetric: String {
        var res = String()
        switch arrow {
        case "↑": res = "↓"
        case "↓": res = "↑"
        case "→": res = "←"
        case "←": res = "→"
        default: break
        }
        return res
    }
    
    func turn90(direction: String) -> String {
        switch direction {
        case "left":
            switch arrow {
            case "↑": return "←"
            case "↓": return "→"
            case "→": return "↑"
            case "←": return "↓"
            default: return ""
            }
        case "right":
            switch arrow {
            case "↑": return "→"
            case "↓": return "←"
            case "→": return "↓"
            case "←": return "↑"
            default: return ""
            }
        default:
            return ""
        }
    }
}
