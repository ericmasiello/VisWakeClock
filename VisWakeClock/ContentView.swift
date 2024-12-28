//
//  ContentView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 9/15/24.
//

import Sentry
import Statsig
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
    Statsig.updateUserWithResult(StatsigUser(userID: userConfig.stringId))
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
        /**
         I'm unclear if this is the best pattern but the Statsig docs recommend flushing the events when the app goes inactive/background.
         See https://docs.statsig.com/client/iosClientSDK#shutting-statsig-down
         */
        if newPhase == .inactive || newPhase == .background {
          Statsig.shutdown()
        }
      }
  }
}

#Preview {
  let userConfig = UserConfiguration(wakeupTime: DateHelper.createDateFromString(hour: 8, minute: 15)!)

  return ContentView(userConfig: userConfig)
    .preferredColorScheme(.dark)
}
