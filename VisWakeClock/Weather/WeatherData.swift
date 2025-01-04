//
//  WeatherData.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

import Foundation

struct WeatherData: Decodable {
  var latitude: Float
  var longitude: Float
  var timezone: String
  var elevation: Float
  
  var current: Current
  var currentUnits: CurrentUnits
  
  enum CodingKeys: String, CodingKey {
    case latitude
    case longitude
    case timezone
    case elevation
    case current
    case currentUnits = "current_units"
  }
  
  struct CurrentUnits: Decodable {
    var time: String
    var interval: String
    var temperature2m: String
    var relativeHumidity2m: String
    var apparentTemperature: String
    var isDay: String
    var precipitation: String
    var rain: String
    var showers: String
    var snowfall: String
    var weatherCode: String
    var cloudCover: String
    var windSpeed10m: String
    
    enum CodingKeys: String, CodingKey {
      case time
      case interval
      case temperature2m = "temperature_2m"
      case relativeHumidity2m = "relative_humidity_2m"
      case apparentTemperature = "apparent_temperature"
      case isDay = "is_day"
      case precipitation
      case rain
      case showers
      case snowfall
      case weatherCode = "weather_code"
      case cloudCover = "cloud_cover"
      case windSpeed10m = "wind_speed_10m"
    }
  }
  
  struct Current: Decodable {
    var time: Int
    var interval: Int
    var temperature2m: Float
    var relativeHumidity2m: Int
    var apparentTemperature: Float
    var isDay: Int
    var precipitation: Float
    var rain: Float
    var showers: Float
    var snowfall: Float
    var weatherCode: Int
    var cloudCover: Float
    var windSpeed10m: Float
    
    enum CodingKeys: String, CodingKey {
      case time
      case interval
      case temperature2m = "temperature_2m"
      case relativeHumidity2m = "relative_humidity_2m"
      case apparentTemperature = "apparent_temperature"
      case isDay = "is_day"
      case precipitation
      case rain
      case showers
      case snowfall
      case weatherCode = "weather_code"
      case cloudCover = "cloud_cover"
      case windSpeed10m = "wind_speed_10m"
    }
  }
}
