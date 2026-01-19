import Playgrounds
import SwiftUI
//
//  OffsetClock.swift
//  VisWakeClock
//
//  Created by Eric Masiello on 1/19/26.
//

struct CountdownView: View {
  @State private var enabled: Bool = false
  @State private var pulse: Bool = false
  var size: CGFloat = 10
  var viewMode: ViewMode = .dim
  var now: Date
  var offsetMinutes: Int = 30
  @StateObject private var countdownManager = CountdownManager()

  var countdown: some View {
    let unit = countdownManager.displayUnit.name
    let minsAsString = String(countdownManager.displayValue)
    let ui = minsAsString.map { ch in
      FlipClockNumberView(value: String(ch), size: size, color: .pink)
    }

    let unitUi = unit.split(separator: "").map {
      FlipClockNumberView(value: String($0), size: size * 0.75)
    }

    return HStack(alignment: .firstTextBaseline) {
      ForEach(ui.indices, id: \.self) { index in
        ui[index]
      }
      Spacer().frame(width: size * 0.25, height: size)
      ForEach(unitUi.indices, id: \.self) { index in
        unitUi[index]
      }
    }
  }

  var body: some View {
    if !enabled {
      Button("Start \(offsetMinutes) minute countdown") {
        enabled.toggle()
        pulse.toggle()
        countdownManager.startCountdown(minutes: offsetMinutes)
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
    } else {
      countdown
        .pulseOpacity($pulse, min: 0.5, max: 1.0, duration: 4)
        // resets the enabled state once the countdown is done
        .onReceive(countdownManager.$displayValue) { newValue in
          if enabled && newValue == 0 {
            enabled = false
          }
        }
    }
  }
}

#Preview("Test") {
  let mins = 2234
  let minsAsString = String(mins)
  let ui = minsAsString.split(separator: "").map {
    FlipClockNumberView(value: String($0), size: 20)
  }

  HStack {
    ForEach(ui.indices, id: \.self) { index in
      ui[index]
    }
  }
}

#Preview("1 min countdown") {
  CountdownView(size: 100, now: Date.now, offsetMinutes: 1).preferredColorScheme(.dark)
}

#Preview("2 min countdown") {
  CountdownView(size: 100, now: Date.now, offsetMinutes: 2).preferredColorScheme(.dark)
}

#Preview("Default countdown") {
  CountdownView(size: 100, now: Date.now).preferredColorScheme(.dark)
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

