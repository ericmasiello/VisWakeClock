import Playgrounds
import SwiftData
import SwiftUI
//
//  OffsetClock.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 1/19/26.
//

struct CountdownView: View {
  var seconds: Int

  @State private var enabled: Bool = false
  @State private var pulse: Bool = false
  var textSize: CGFloat = 0
  @StateObject private var countdownManager = CountdownManager()

  var countdown: some View {
    let unit = countdownManager.displayUnit.name
    let minsAsString = String(countdownManager.displayValue)
    let ui = minsAsString.map { ch in
      FlipClockNumberView(value: String(ch), size: textSize, color: .pink)
    }

    let unitUi = unit.split(separator: "").map {
      FlipClockNumberView(value: String($0), size: textSize * 0.75)
    }

    return HStack(alignment: .firstTextBaseline) {
      ForEach(ui.indices, id: \.self) { index in
        ui[index]
      }
      Spacer().frame(width: textSize * 0.25, height: textSize)
      ForEach(unitUi.indices, id: \.self) { index in
        unitUi[index]
      }
    }
  }
  
  var countDownLabel: String {
    if seconds < 60 {
      return "\(seconds) second"
    }
    return "\(seconds / 60) minute"
  }

  var message: String {
    if enabled {
      "Countdown: \(String(countdownManager.displayValue)) \(countdownManager.displayUnit.name)"
    } else {
      "Start \(countDownLabel) countdown"
    }
  }

  var body: some View {
    Button(message) {
      enabled.toggle()
      countdownManager.startCountdown(seconds: seconds)
    }
    .font(Font.largeTitle.bold())
    .padding(.horizontal, 24)
    .padding(.vertical, 12)
    .buttonStyle(.bordered)
    .buttonBorderShape(.capsule)
    .tint(pulse ? .pink : .pink.opacity(0.7))
    .overlay(
      Capsule()
        .stroke(pulse ? Color.pink : Color.pink.opacity(0.7), lineWidth: 2)
    )
    .pulseOpacity($pulse, min: 0.5, max: 1.0, duration: 3)
  }
}

#Preview("Default countdown with user config") {
  let config = ModelConfiguration(isStoredInMemoryOnly: true)
  let container = try! ModelContainer(for: UserConfiguration.self, configurations: config)

  let userConfig = UserConfiguration(
    wakeupTime: DateHelper.createDateFromString(hour: 6, minute: 15)!
  )

  CountdownView(seconds: userConfig.countdownMinutes * 60, textSize: 100).preferredColorScheme(.dark)
}

#Preview("2 min countdown") {
  CountdownView(seconds: 120, textSize: 100).preferredColorScheme(.dark)
}

#Preview("1 min countdown") {
  CountdownView(seconds: 60, textSize: 100).preferredColorScheme(.dark)
}

#Preview("10 sec countdown") {
  CountdownView(seconds: 10, textSize: 100).preferredColorScheme(.dark)
}

// MARK: - Reusable Pulse Opacity Modifier

private struct PulseOpacityModifier: ViewModifier {
  @Binding var isPulsing: Bool
  var minOpacity: Double
  var maxOpacity: Double
  var duration: Double

  func body(content: Content) -> some View {
    content
      .opacity(isPulsing ? maxOpacity : minOpacity)
      .onAppear {
        withAnimation(.easeInOut(duration: duration).repeatForever(autoreverses: true)) {
          isPulsing = true
        }
      }
  }
}

private extension View {
  func pulseOpacity(_ isPulsing: Binding<Bool>, min: Double = 0.5, max: Double = 1.0, duration: Double = 1.2) -> some View {
    modifier(PulseOpacityModifier(isPulsing: isPulsing, minOpacity: min, maxOpacity: max, duration: duration))
  }
}
