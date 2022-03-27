//
//  WeatherDTO.swift
//  
//
//  Created by Veronika Babii on 04.11.2021.
//

import Foundation
import Vapor

struct WeatherDTO: Codable, Content {
    let id: Int
    let weatherStateName: String
    let weatherStateAbbr: String
    let windDirectionCompass: String
    let created: String
    let applicableDate: String
    let minTemp: Double
    let maxTemp: Double
    let temp: Double
    let windSpeed: Double
    let windDirection: Double
    let airPressure: Double
    let humidity: Int
    let visibility: Double?
    let predictability: Int
    
    enum CodingKeys: String, CodingKey {
        case weatherStateName = "weather_state_name"
        case weatherStateAbbr = "weather_state_abbr"
        case windDirectionCompass = "wind_direction_compass"
        case applicableDate = "applicable_date"
        case minTemp = "min_temp"
        case maxTemp = "max_temp"
        case temp = "the_temp"
        case windSpeed = "wind_speed"
        case windDirection = "wind_direction"
        case airPressure = "air_pressure"
        case humidity, visibility, predictability, created, id
    }
}
