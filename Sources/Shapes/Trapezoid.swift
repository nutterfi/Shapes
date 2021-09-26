//
//  Trapezoid.swift
//  
//
//  Created by nutterfi on 9/25/21.
//

import SwiftUI

public struct Trapezoid: Polygon {
  public var inset: CGFloat = .zero
  
  /// percentage of width where the top left vertex is placed. Must be between 0 and 1.0
  public var pct1: CGFloat = 0.25
  
  /// percentage of width where the top right vertex is placed. Must be between 0 and 1.0
  public var pct2: CGFloat = 0.75
  
  public var sides: Int = 4
  
  public init(pct1: CGFloat = 0.25, pct2: CGFloat = 0.75) {
    self.pct1 = min(pct1, pct2)
    self.pct2 = max(pct1, pct2)
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    [
      CGPoint(x: rect.minX, y: rect.maxY), // lower left
      CGPoint(x: rect.minX + pct1 * rect.width, y: rect.minY), // upper left
      CGPoint(x: rect.minX + pct2 * rect.width, y: rect.minY), // upper right
      CGPoint(x: rect.maxX, y: rect.maxY)  // lower right
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path {path in
      path.addLines(vertices(in: aRect))
      path.closeSubpath()
    }
  }
   
}

struct Trapezoid_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        Trapezoid(pct1: 0.7, pct2: 0.3)
          .frame(width: 256, height: 128)
          .border(Color.gray)

        Trapezoid()
          .inset(by: 20)
          .frame(width: 256, height: 128)
        .border(Color.gray)
      }
    }
}
