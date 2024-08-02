//
//  SkewedShape.swift
//
//
//  Created by nutterfi on 8/2/24.
//

import SwiftUI
import CoreGraphics

/// A shape with a skew transform applied to it.
public struct SkewedShape<S: Shape>: Shape {
  /// The underlying shape to be transformed
  public var shape: S
  
  /// Skew factor in both horizontal and vertical directions
  public var skew: CGVector = .zero
  
  /// The relative position of the skew
  public var anchor: UnitPoint = .center
  
  public init(shape: S, skew: CGVector, anchor: UnitPoint) {
    self.shape = shape
    self.skew = skew
    self.anchor = anchor
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let anchorOffset = CGSize(
        width: rect.width * anchor.x,
        height: rect.height * anchor.y
      )
      
      let skewedPath = shape.path(in: rect)
        .offsetBy(dx: -anchorOffset.width, dy: -anchorOffset.height)
        .applying(CGAffineTransform(skewX: skew.dx, y: skew.dy))
        .offsetBy(dx: anchorOffset.width, dy: anchorOffset.height)
      
      path.addPath(skewedPath)
    }
  }
}

#Preview {
  SkewedShape(shape: .circle, skew: .init(dx: 1, dy: 0))
}
