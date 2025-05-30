//
//  WeatherManager.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 11/1/24.
//

import Combine
import CoreLocation

enum WeatherError: Error {
  case invalidResponse
  case networkError(Error)
  case invalidData
}

enum WeatherDataStatus {
  case idle
  case loading
  case ready(WeatherData)
  case error(Error)
}

class WeatherManager: ObservableObject {
  @Published var status: WeatherDataStatus = .idle

  private var cachedCoordinates: (latitude: Double, longitude: Double)? = nil
  private var locationChangeCancellables = Set<AnyCancellable>()
  private let timerFrequency = 1.0 * 60 * 30 // fetch weather every 30 mins
  private var timerCancellable: AnyCancellable?
  private var coordinateChangeTask: Task<Void, Never>?
  private var timerTask: Task<Void, Never>?

  init(locationManager: LocationManager) {
    // Subscribe to location updates
    locationManager.coordinatesPublisher
      .sink { [weak self] coordinates in
        debugPrint("[coordinates change] Fetching Weather Data from WeatherManager")
        self?.status = .loading

        self?.cachedCoordinates = (latitude: coordinates.latitude, longitude: coordinates.longitude)

        self?.coordinateChangeTask = Task {
          do {
            guard let weatherData = try await WeatherClient.getWeather(
              latitude: coordinates.latitude, longitude: coordinates.longitude) else {
              throw WeatherError.invalidData
            }
            self?.status = .ready(weatherData)
          } catch {
            self?.status = .error(error)
            ErrorLogger.log(error: error)
          }
        }

      }
      .store(in: &locationChangeCancellables)

    self.timerCancellable = Timer.publish(every: timerFrequency, on: .main, in: .default)
      .autoconnect() // Automatically connect to start receiving updates
      .sink { [weak self] _ in
        self?.timerTask = Task {
          debugPrint("[timer] Fetching Weather Data from WeatherManager")
          self?.status = .loading
          
          guard let coordinates = self?.cachedCoordinates else { return }

          do {
            guard let weatherData = try await WeatherClient.getWeather(
              latitude: coordinates.latitude, longitude: coordinates.longitude) else {
              throw WeatherError.invalidData
            }
            self?.status = .ready(weatherData)
          } catch {
            self?.status = .error(error)
            ErrorLogger.log(error: error)
          }
        }
      }
  }

  deinit {
    // cancel all cancellables
    timerCancellable?.cancel()
    locationChangeCancellables.forEach { value in value.cancel() }
    timerTask?.cancel()
    coordinateChangeTask?.cancel()
  }
}
