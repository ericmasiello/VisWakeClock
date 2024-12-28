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
  @State private var navigationPath = NavigationPath()

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
  }
}

#Preview {
  let userConfig = UserConfiguration(wakeupTime: DateHelper.createDateFromString(hour: 8, minute: 15)!)
  
  return ContentView(userConfig: userConfig)
    .preferredColorScheme(.dark)
}
