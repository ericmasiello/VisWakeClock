import SwiftUI

//
//  BounceView.swift
//  VisWake Clock
//
//  Created by Eric Masiello on 10/31/24.
//

struct BounceView<Content: View, R: Hashable>: View {
  var recomputeValue: R
  @ViewBuilder let content: Content
  @State private var position: CGPoint = .init(x: 0, y: 0)
  @State private var velocity: CGSize = .init(width: 4, height: 4)
  @State private var viewSize: CGSize = .init(width: 0, height: 0)
  
  // Control speed of animation
  let animationDuration = 1.00

  func updatePositionAndVelocity() {
    var newPos = position
    var newVelocity = velocity

    // Update position based on velocity
    newPos.x += newVelocity.width
    newPos.y += newVelocity.height

    // Bounce off the horizontal edges
    if newPos.x - viewSize.width / 2 <= 0 || newPos.x + viewSize.width / 2 >= UIScreen.main.bounds.width {
      newVelocity.width = -newVelocity.width
    }

    // Bounce off the vertical edges
    if newPos.y - viewSize.height / 2 <= 0 || newPos.y + viewSize.height / 2 >= UIScreen.main.bounds.height {
      newVelocity.height = -newVelocity.height
    }

    // Apply updates
    position = newPos
    velocity = newVelocity
  }

  var body: some View {
    ZStack {
      content.background(
        GeometryReader { contentViewProxy in
          Color.clear
            .onAppear {
              viewSize = contentViewProxy.size // Measure view size
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
        }
          .id(recomputeValue) // forces the geometry reader to rerun when the recomputeValue changes
      )
      .position(position)
      .onAppear {
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { _ in
          withAnimation(.linear(duration: animationDuration)) {
            // skip animating until the viewSize is updated by the child view
            if viewSize.width > 0 && viewSize.height > 0 {
              updatePositionAndVelocity()
            }
          }
        }
      }
      /**
       * kludge: for reasons I don't yet understand, upon rotating the device, the bounce view seems to miscalculate the the dimensions of the view its bouncing and ends up overshooting the screensize.
       * However, if I nest the view inside a ZStack and render a clear view the full size of the UI, it works more consistently.
       */
      Color.clear
        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
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
