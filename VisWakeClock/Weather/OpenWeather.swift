//
//  OpenWeather.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/24/24.
//
import Foundation
import OpenMeteoSdk

class WeatherClient {
  static func getWeather(latitude: Double, longitude: Double) async throws -> WeatherData? {
    let url = URL(
      string:
      "https://api.open-meteo.com/v1/forecast?latitude=\(latitude)&longitude=\(longitude)&current=temperature_2m,relative_humidity_2m,apparent_temperature,is_day,precipitation,rain,showers,snowfall,weather_code,cloud_cover,wind_speed_10m&daily=weather_code,temperature_2m_max,temperature_2m_min,apparent_temperature_max,apparent_temperature_min,precipitation_sum,rain_sum,showers_sum,snowfall_sum,precipitation_hours,precipitation_probability_max,wind_speed_10m_max,wind_gusts_10m_max&temperature_unit=fahrenheit&wind_speed_unit=mph&precipitation_unit=inch&timeformat=unixtime&timezone=America%2FNew_York&forecast_days=3&format=json"
    )!
    
    var data: Data?
    
    do {
      let (weatherData, _) = try await URLSession.shared.data(from: url)
      data = weatherData
    } catch {
      /**
       * Check if error is due to being offline, if so, fail silently. Else, throw the error to SentrySDK
       */
      if let urlError = error as? URLError {
        // Check if the error is a network-related issue (offline, no connection, etc.)
        switch urlError.code {
        case .notConnectedToInternet, .networkConnectionLost:
          // silently fail due to offline errors
          print("Network error: No internet connection or network connection lost.")
          return nil
        case .timedOut:
          // silently fail due to offline errors
          print("Network error: Connection timed out.")
          return nil
        default:
          throw error
        }
      } else {
        // Handle other errors (e.g., decoding errors, unexpected errors)
        throw error
      }
    }
    
    guard let data = data else {
      return nil
    }
    
    let weather = try JSONDecoder().decode(WeatherData.self, from: data)
    
    return weather
  }
}
