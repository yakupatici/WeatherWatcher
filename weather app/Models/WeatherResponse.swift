struct WeatherResponse: Codable {
    let main: Main
    let wind: Wind
    let name: String
    let weather: [Weather]
    
    
    struct Main: Codable {
        let temp: Double
        let temp_min: Double
        let temp_max: Double
        let pressure: Int
        let humidity: Int
    }
    
    struct Wind: Codable {
        let speed: Double
    }
    
    struct Weather: Codable {
        let description: String
        let icon: String
    }
}

