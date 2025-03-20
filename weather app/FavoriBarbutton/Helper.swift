import Foundation

class Helper {
    static func roundedTemperature(_ temperature: Double) -> String {
        let roundedTemp = round(temperature)
        return String(format: "%.0f", roundedTemp)
    }
}
