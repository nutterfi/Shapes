//
//  Polygon.swift
//
//  Created by nutterfi on 9/2/21.
//

import SwiftUI

/// A plane figure that is described by a finite number of straight line segments connected to form a closed polygonal chain
public protocol Polygon: Shape {
  var sides: Int { get }
  func vertices(in rect: CGRect) -> [CGPoint]
}

/// A polygon with equal-length sides and equally-spaced vertices along a circumscribed circle
public protocol RegularPolygon: Polygon {}

public extension RegularPolygon {
  // obtains p equally spaced points around a circle inscribed in rect
  func vertices(in rect: CGRect) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    return Array(0 ..< sides).map {
      let theta = 2 * .pi * CGFloat($0) / CGFloat(sides)
      return CGPoint(x: origin.x + r * cos(theta), y: origin.y + r * sin(theta))
    }
  }
}