//
//  IsotoxalPolygon.swift
//  
//
//  Created by nutterfi on 10/16/21.
//

import SwiftUI

public struct IsotoxalPolygon: Polygon {
  public var sides: Int
  public var innerRadius: CGFloat
  
  public var inset: CGFloat = .zero
  
  // sides: should be a positive even number. Undefined behavior if odd numbered
  // innerRadius: should be between 0...1
  public init(sides: Int, innerRadius: CGFloat = 1.0) {
    self.sides = abs(sides)
    self.innerRadius = innerRadius
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    return Array(0 ..< sides).map {
      let radius = $0 % 2 == 0 ? r : r * innerRadius
      let theta = 2 * .pi * CGFloat($0) / CGFloat(sides) - .pi / 2 // the origin will now be facing north
      return CGPoint(x: origin.x + radius * cos(theta), y: origin.y + radius * sin(theta))
    }
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect.insetBy(dx: inset, dy: inset)))
      path.closeSubpath()
    }
  }
  
  
}

struct IsotoxalPolygon_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      let innerRadius: CGFloat = 0.5
      Circle().stroke()
      IsotoxalPolygon(sides: 8, innerRadius: innerRadius)
      
      IsotoxalPolygon(sides: 8, innerRadius: innerRadius)
        .inset(by: 50)
        .fill(Color.blue)

    }
    .frame(width: 256, height: 512)
  }
}
