//
//  WeatherAlert.swift
//  weather app
//
//  Created by Yakup Atıcı on 18.08.2024.
//

import Foundation
struct WeatherAlert: Decodable {
    let title: String
    let description: String
    let start: Int
    let end: Int
}
