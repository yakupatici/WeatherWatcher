//
//  HourlyWeather.swift
//  weather app
//
//  Created by Yakup Atıcı on 11.08.2024.
//

import Foundation
struct HourlyWeatherResponse: Codable {
    let hourly: [Hourly]
    
    struct Hourly: Codable {
        let dt: Int
        let temp: Double
    }
}
