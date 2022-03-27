//
//  AdviceDTO.swift
//  
//
//  Created by Veronika Babii on 03.11.2021.
//

import Foundation
import Vapor

struct AdviceDTO: Codable, Content {
    let shouldWearHat: Bool
    let shouldWearSunglasses: Bool
    let shouldTakeUmbrella: Bool
    let shouldWearRaincoat: Bool
    let shouldWearScarf: Bool
    let shouldWearPanama: Bool
    let shouldUseSunscreen: Bool
    
    enum CodingKeys: String, CodingKey {
        case shouldWearHat = "should_wear_hat"
        case shouldWearSunglasses = "should_wear_sunglasses"
        case shouldTakeUmbrella = "should_take_umbrella"
        case shouldWearRaincoat = "should_wear_raincoat"
        case shouldWearScarf = "should_wear_scarf"
        case shouldWearPanama = "should_wear_panama"
        case shouldUseSunscreen = "should_use_sunscreen"
    }
}
