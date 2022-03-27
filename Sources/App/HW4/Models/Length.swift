//
//  Length.swift
//  
//
//  Created by Veronika Babii on 07.10.2021.
//

import Foundation

struct Length {
    var value: Float
    
    var distance: String {
        switch value {
        case 1.0...: return "\(value)m"
        case 0.1...1.0: return "\(value*10)dm"
        case 0.01...0.1: return "\(Int(value*100))cm"
        default: return ""
        }
    }
}
