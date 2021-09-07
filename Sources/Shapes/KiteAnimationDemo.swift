//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

struct KiteAnimationDemo: View {
  @State private var isAnimating: Bool = false
    var body: some View {
      GeometryReader { proxy in
        let dim = min(proxy.size.width, proxy.size.height)
        ZStack {
          Kite(pointRatio: isAnimating ? 1.0 : 0.0)
            .foregroundColor(.red)
            .frame(width: dim, height: dim)
            .animation(Animation.easeInOut(duration: 2).repeatForever(), value: isAnimating)
          
          RightKite(pointRatio: isAnimating ? 1.0 : 0.0)
            .foregroundColor(.yellow)
            .frame(width: dim, height: dim)
            .animation(Animation.easeInOut(duration: 2).repeatForever(), value: isAnimating)
          
          RightKite(pointRatio: isAnimating ? 1.0 : 0.0)
            .foregroundColor(.orange)
            .frame(width: dim, height: dim)
            .animation(Animation.easeInOut(duration: 1).repeatForever(), value: isAnimating)
        }
        .opacity(0.8)
        .rotationEffect(.degrees(isAnimating ? 360 : 0))
        .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
        .onAppear {
          isAnimating = true
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
}

struct KiteAnimationDemo_Previews: PreviewProvider {
    static var previews: some View {
      KiteAnimationDemo()
        .frame(width: 256, height: 256)
    }
}
