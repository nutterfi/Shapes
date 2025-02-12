//
//  VectorPoint.swift
//  Shapes
//
//  Created by nutterfi on 2/9/25.
//


import SwiftUI

/// A UnitPoint equivalent used to conform to VectorArithmetic.
public struct VectorPoint: Hashable, Sendable {
  public var x: CGFloat
  public var y: CGFloat
  
  public init(x: CGFloat, y: CGFloat) {
    self.x = x
    self.y = y
  }
  
  public init(_ point: UnitPoint) {
    x = point.x
    y = point.y
  }
  
  public var unitPoint: UnitPoint {
    UnitPoint(x: x, y: y)
  }
}

extension VectorPoint: Animatable {
  public var animatableData: AnimatablePair<CGFloat, CGFloat> {
    get {
      AnimatablePair(x, y)
    }
    set {
      x = newValue.first
      y = newValue.second
    }
  }
}

extension VectorPoint: AdditiveArithmetic {
  public static var zero: VectorPoint {
    VectorPoint(x: 0, y: 0)
  }
}

extension VectorPoint: VectorArithmetic {
  public static func - (lhs: VectorPoint, rhs: VectorPoint) -> VectorPoint {
    VectorPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }
  
  public mutating func scale(by rhs: Double) {
    x *= rhs
    y *= rhs
  }
  
  public var magnitudeSquared: Double {
    x * x + y * y
  }
  
  public static func + (lhs: VectorPoint, rhs: VectorPoint) -> VectorPoint {
    VectorPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
  
}
