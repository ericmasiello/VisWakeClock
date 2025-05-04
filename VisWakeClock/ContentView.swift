//
//  ContentView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 9/15/24.
//

import SwiftData
import SwiftUI

enum NavigationDestinations: String, CaseIterable, Hashable {
  case Clock
  case Settings
}

struct ContentView: View {
  let userConfig: UserConfiguration
  @Environment(\.scenePhase) var scenePhase
  @State private var navigationPath = NavigationPath()

  init(userConfig: UserConfiguration) {
    self.userConfig = userConfig

    AnalyticsLogger.updateUserWithResult(userId: userConfig.stringId)
  }

  var body: some View {
    let handleTapBack: HandleBackTapped = {
      navigationPath.append(NavigationDestinations.Settings)
    }

    NavigationStack(path: $navigationPath) {
      HomeClockView(userConfiguration: userConfig, handleBackTapped: handleTapBack)
        .navigationDestination(for: NavigationDestinations.self) { screen in
          switch screen {
          case .Settings:
            SettingsView(userConfiguration: userConfig)
          default:
            HomeClockView(userConfiguration: userConfig, handleBackTapped: handleTapBack)
          }
        }
    }
    .edgesIgnoringSafeArea(.all)
    #if os(iOS)
      .statusBar(hidden: true)
    #endif
      .onChange(of: scenePhase) { _, newPhase in
        AnalyticsLogger.shutDown(scenePhase: newPhase)
      }
  }
}

#Preview {
  let userConfig = UserConfiguration(wakeupTime: DateHelper.createDateFromString(hour: 8, minute: 15)!)

  return ContentView(userConfig: userConfig)
    .preferredColorScheme(.dark)
}
