//
//  SimplePolygonDemo.swift
//
//  Created by nutterfi on 9/9/21.
//

import SwiftUI

struct SimplePolygonDemo: View {
  @State private var isAnimating: Bool = false

    var body: some View {
      GeometryReader { proxy in
        ZStack {
          let dim = min(proxy.size.width, proxy.size.height)
          let gradient = RadialGradient(colors: [.white, .blue], center: .center, startRadius: dim / 10, endRadius: dim )
          
          SimplePolygon(sides: 4)
            .fill(gradient)
            .rotationEffect(.degrees(isAnimating ? 50 : 0))
            .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
          SimplePolygon(sides: 5)
            .fill(gradient)

            .rotationEffect(.degrees(isAnimating ? 103 : 0))
            .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
          SimplePolygon(sides: 7)
            .fill(gradient)

            .rotationEffect(.degrees(isAnimating ? -180 : 180))
            .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
          SimplePolygon(sides: 10)
            .fill(gradient)

            .rotationEffect(.degrees(isAnimating ? 180 : -180))
            .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
        }
        .opacity(0.3)
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
      .onAppear {
        isAnimating = true
      }
    }
}

struct SimplePolygonDemo_Previews: PreviewProvider {
    static var previews: some View {
      SimplePolygonDemo()
    }
}
