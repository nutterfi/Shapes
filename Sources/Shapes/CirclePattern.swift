//
//  CirclePattern.swift
//  
//
//  Created by nutterfi on 12/28/21.
//

import SwiftUI

/// Generates a repeated pattern of the provided view on a circular path
public struct CirclePattern<T: View>: View {
  var pattern: T
  var repetitions: Int
  
  public init(pattern: T, repetitions: Int = 10) {
    self.pattern = pattern
    self.repetitions = repetitions
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let dim = min(proxy.size.width, proxy.size.height)
      let rect = proxy.frame(in: .local)
      let vertices = ConvexPolygon(
        sides: repetitions)
        .vertices(in: rect)
      
      ZStack {
        ForEach(0..<repetitions) { index in
          let vertex = vertices[index]
          let angle = atan2((vertex.y - rect.midY), (vertex.x - rect.midX))
          
          pattern
            .frame(width: dim / CGFloat(repetitions), height: dim / CGFloat(repetitions))
            .rotationEffect(.radians(angle + CGFloat.pi / 2))
            .offset(x: -dim * 0.5 + vertex.x, y: -dim * 0.5 + vertex.y)
        }
      }
      .frame(width: proxy.size.width, height: proxy.size.height)
    }
  }
}

struct CirclePattern_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Color.black.ignoresSafeArea()
      Circle()
        .strokeBorder(Color.orange, lineWidth: 10)
      
      CirclePattern(pattern: Text("A").font(.system(size: 12)), repetitions: 20)
        .frame(width: 350, height: 350)
        .foregroundColor(.orange)
      
      CirclePattern(pattern: Reuleaux.triangle, repetitions: 20)
        .frame(width: 300, height: 300)
        .foregroundColor(.orange)
      
      CirclePattern(pattern: TriquetraView(), repetitions: 5)
        .frame(width: 200, height: 200)
        .foregroundColor(.orange)
    }
  }
}
