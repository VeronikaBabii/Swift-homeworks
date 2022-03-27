//
//  LightDTO.swift
//  
//
//  Created by Veronika Babii on 16.10.2021.
//

import Foundation
import Vapor

struct LightDTO: Codable, Content {
    let lightOn: Bool
    let effect: String
    let colors: [String]
    let speed: String?
    let direction: String?
}
