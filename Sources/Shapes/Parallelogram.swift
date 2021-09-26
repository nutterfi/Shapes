//
//  Parallelogram.swift
//  
//
//  Created by nutterfi on 9/25/21.
//

import SwiftUI

public struct Parallelogram: Polygon {
  public var inset: CGFloat = .zero
  
  /// percentage of width where the top left and bottom right vertices are placed. Must be between 0 and 1.0
  public var pct: CGFloat = 0.3
  public var sides: Int = 4
  
  public init(pct: CGFloat = .zero) {
    self.pct = abs(pct)
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    [
      CGPoint(x: rect.minX, y: rect.maxY), // lower left
      CGPoint(x: rect.minX + pct * rect.width, y: rect.minY), // upper left
      CGPoint(x: rect.maxX, y: rect.minY), // upper right
      CGPoint(x: rect.maxX - pct * rect.width, y: rect.maxY)  // lower right
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

struct Parallelogram_Previews: PreviewProvider {
    static var previews: some View {
      Parallelogram(pct: 0.5)
        .inset(by: 20)
        .frame(width: 256, height: 128)
        .border(Color.gray)
    }
}
