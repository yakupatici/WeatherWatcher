//
//  Earhtquake.swift
//  Hava Durumu Takip
//
//  Created by Yakup Atici on 7.09.2024.
//

import Foundation
struct EarthquakeResponse: Codable {
    let status: Bool
    let httpStatus: Int
    let result: [Earthquake]
}

struct Earthquake: Codable {
    let earthquake_id: String
    let provider: String
    let title: String
    let date: String
    let mag: Double
    let depth: Double
    let geojson: GeoJSON
    let location_properties: LocationProperties
}

struct GeoJSON: Codable {
    let type: String
    let coordinates: [Double]
}

struct LocationProperties: Codable {
    let closestCity: City
    let epiCenter: City
}

struct City: Codable {
    let name: String
    let cityCode: Int
    let distance: Double
    let population: Int
}
