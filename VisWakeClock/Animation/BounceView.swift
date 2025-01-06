import SwiftUI

//
//  BounceView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

struct BounceView<Content: View, R: Hashable>: View {
  var recomputeValue: R
  @State private var timer: Timer? = nil
  @ViewBuilder let content: Content
  @State private var position: CGPoint = .init(x: 0, y: 0)
  @State private var velocity: CGSize = .init(width: 4, height: 4)
  @State private var contentSize: CGSize = .init(width: 0, height: 0)

  func updatePositionAndVelocity() {
    var newPos = position
    var newVelocity = velocity

    // Update position based on velocity
    newPos.x += newVelocity.width
    newPos.y += newVelocity.height

    // Bounce off the horizontal edges
    if newPos.x - contentSize.width / 2 <= 0 || newPos.x + contentSize.width / 2 >= UIScreen.main.bounds.width {
      newVelocity.width = -newVelocity.width
    }

    // Bounce off the vertical edges
    if newPos.y - contentSize.height / 2 <= 0 || newPos.y + contentSize.height / 2 >= UIScreen.main.bounds.height {
      newVelocity.height = -newVelocity.height
    }

    // Apply updates
    position = newPos
    velocity = newVelocity
  }

  var body: some View {
    content.background(
      GeometryReader { contentViewProxy in
        Color.clear
          .onAppear {
            contentSize = contentViewProxy.size // Measure view size

            /**
             * @note: We set the screenSize and position initially inside the scope of the GeometryReader
             * because we need to reset these values whenever the orientation changes. We trigger re-rendering the
             * GeometryReader by setting the `id(recomputeValue)`. This forces it to recalculate whenever the
             * orientation changes
             */
            // we reset the position of the view whenever recompute value changes
            position.x = UIScreen.main.bounds.midX
            position.y = UIScreen.main.bounds.midY
          }
          .id(recomputeValue) // forces the geometry reader to rerun when the recomputeValue changes
      }
    )
    .position(position)
    .onAppear {
      /**
       * Set the framerate to an internal of 1/60 to get 60fps.
       * I then multiply it by 6 to slow it down to a reasonable speed, otherwise
       * bounce animation is too fast.
       */
      let frameRate: Double = (1 / 60) * 6

      timer = Timer.scheduledTimer(withTimeInterval: frameRate, repeats: true) { _ in
        withAnimation(.linear(duration: frameRate)) {
          // skip animating until the viewSize is updated by the child view
          if contentSize.width > 0 && contentSize.height > 0 {
            updatePositionAndVelocity()
          }
        }
      }
      
      guard let timer = timer else {
        return
      }
      // Keep timer running even when scrolling
      RunLoop.current.add(timer, forMode: .common)
      
    }
    .onDisappear {
      // fixes https://github.com/ericmasiello/VisWakeClock/issues/13
      timer?.invalidate()
    }
  }
}

#Preview {
  BounceView(recomputeValue: 0) {
    VStack(alignment: .leading, spacing: 0) {
      EmojiView(option: .rain, size: 100)
      ClockView(size: 100, viewMode: .active, now: Date())
      HStack {
        Spacer()
        TemperatureView(temperatureF: 24.3)
      }
    }
    .fixedSize()
  }
  .preferredColorScheme(.dark)
}
