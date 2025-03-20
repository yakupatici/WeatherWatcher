//
//  HistoricalWeatherResponse.swift
//  weather app
//
//  Created by Yakup Atıcı on 11.08.2024.
//
struct HistoricalWeatherResponse: Codable {
    let data: [WeatherData]
}

struct WeatherData: Codable {
    let date: String
    let temperature: Double
    // Add other weather properties here
}
