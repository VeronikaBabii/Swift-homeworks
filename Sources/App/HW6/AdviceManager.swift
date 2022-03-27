//
//  AdviceManager.swift
//
//  Created by Veronika Babii on 03.11.2021.
//

import Foundation
import Vapor

@available(macOS 12.0.0, *)
class AdviceManager {
    
    func getAdvice(for cityName: String, on date: Date) async throws -> AdviceDTO {
        async let woeid = processCityName(cityName)
        
        let year = date.get(.year)
        let month = date.get(.month)
        let day = date.get(.day)
        let urlStr = "https://www.metaweather.com/api/location/\(try await woeid)/\(year)/\(month)/\(day)"
        
        guard let url = URL(string: urlStr) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Error creating URL"))
        }
        
        do {
            async let (weatherData, _) = URLSession.shared.data(from: url)
            let allWeather = try await JSONDecoder().decode([WeatherDTO].self, from: weatherData)
            
            guard let weather = allWeather.first else {
                throw Abort(.custom(code: 404, reasonPhrase: "Error getting first weather"))
            }
            
            let advice = parseToAdviceDTO(from: weather)
            return advice
        } catch {
            throw Abort(.custom(code: 404, reasonPhrase: "Error getting advice"))
        }
    }
    
    func processCityName(_ cityName: String) async throws -> Int {
        let urlStr = "https://www.metaweather.com/api/location/search/?query=\(cityName)"
        guard let url = URL(string: urlStr) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Error creating URL"))
        }
        
        do {
            async let (woeidData, _) = URLSession.shared.data(from: url)
            guard let woeid = try await JSONDecoder().decode([CityDTO].self, from: woeidData).first?.woeid else {
                throw Abort(.custom(code: 404, reasonPhrase: "Error getting woeid"))
            }
            return woeid
        } catch {
            throw Abort(.custom(code: 404, reasonPhrase: "Error processing city name"))
        }
    }
    
    func parseToAdviceDTO(from weatherDTO: WeatherDTO) -> AdviceDTO {
        let stateAbr = weatherDTO.weatherStateAbbr
        let temp = weatherDTO.temp
        let windSpeed = weatherDTO.windSpeed
        
        let clear = stateAbr == "c"
        let rain = ["hr", "lr", "s", "sn", "sl", "h", "t"].contains(stateAbr)
        let aboveZero = temp > 0
        
        let wearHat = (5...15 ~= temp && windSpeed > 5) || temp < 5 ? true : false
        let wearSunglasses = clear ? true : false
        let takeUmbrella = rain && aboveZero && windSpeed < 7 ? true : false
        let wearRaincoat = rain && aboveZero && windSpeed >= 7 ? true : false
        let wearScarf = (0...10 ~= temp && windSpeed > 4) || temp < 0 ? true : false
        let wearPanama = clear && temp > 30 ? true : false
        let useSunscreen = clear && temp > 23 ? true : false
        
        let adviceDTO = AdviceDTO(shouldWearHat: wearHat, shouldWearSunglasses: wearSunglasses, shouldTakeUmbrella: takeUmbrella, shouldWearRaincoat: wearRaincoat, shouldWearScarf: wearScarf, shouldWearPanama: wearPanama, shouldUseSunscreen: useSunscreen)
        return adviceDTO
    }
    
    func getDate(from dateStr: String) throws -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd'-'MM'-'yyyy"
        guard let date = dateFormatter.date(from: dateStr) else {
            throw Abort(.custom(code: 404, reasonPhrase: "Error getting date"))
        }
        return date
    }
}

// MARK: - Extensions

extension Date {
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
}
