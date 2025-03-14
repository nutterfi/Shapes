//
//  Polygon.swift
//
//  Created by nutterfi on 9/2/21.
//

import SwiftUI

/// A plane figure that is described by a finite number of straight line segments connected to form a closed polygonal chain
public protocol Polygon {
  var sides: Int { get }
  func vertices(in rect: CGRect) -> [CGPoint]
}

/// A polygon with equal-length sides and equally-spaced vertices along a circumscribed circle
public protocol RegularPolygon: Polygon {}

public extension RegularPolygon {
  
  /// obtains p equally spaced points around a circle inscribed in rect, arranged clockwise starting at the top of the unit circle
  func vertices(in rect: CGRect) -> [CGPoint] {
    vertices(in: rect, offset: .zero)
  }
  
  /// obtains p equally spaced points around a circle inscribed in rect, arranged clockwise starting at the top of the unit circle, with any additional offset
  func vertices(in rect: CGRect, offset: Angle = .zero) -> [CGPoint] {
    let r = rect.breadth / 2
    let origin = rect.midXY
    let array: [CGPoint] = Array(0 ..< sides).map {
      let theta = 2 * .pi * CGFloat($0) / CGFloat(sides) + CGFloat(offset.radians) - CGFloat.pi / 2  // pointing north!
      return CGPoint(x: origin.x + r * cos(theta), y: origin.y + r * sin(theta))
    }
    return array
  }
}
