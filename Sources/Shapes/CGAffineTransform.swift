//
//  CGAffineTransform.swift
//
//
//  Created by nutterfi on 8/2/24.
//

import Foundation

public extension CGAffineTransform {
  /// Returns an affine transformation matrix constructed from skew values you provide.
  /// - Parameters:
  ///   - x: skewness angle, in radians, in the horizontal direction, from the origin.
  ///   - y: skewness angle, in radians, in the vertical direction, from the origin.
  init(skewAngleX x: CGFloat, y: CGFloat) {
    self.init(skewX: tan(x), y: tan(y))
  }
  
  /// Returns an affine transformation matrix constructed by skewing an existing affine transform.
  /// - Parameters:
  ///   - x: skewness angle, in radians, in the horizontal direction, from the origin.
  ///   - y: skewness angle, in radians, in the vertical direction, from the origin.
  /// - Returns: A new affine transformation matrix. That is, t’ = t1*t2.
  func skewedByAngle(x: CGFloat, y: CGFloat) -> CGAffineTransform {
    concatenating(CGAffineTransform(skewAngleX: x, y: y))
  }
  
  /// Returns an affine transformation matrix constructed from skew values you provide.
  /// - Parameters:
  ///   - x: skewness factor in the horizontal direction, from the origin. This is a dimensionless number.
  ///   - y: skewness factor in the vertical direction, from the origin. This is a dimensionless number.
  init(skewX x: CGFloat, y: CGFloat) {
    self.init(1, y, x, 1, 0, 0)
  }

  /// Returns an affine transformation matrix constructed by skewing an existing affine transform.
  /// - Parameters:
  ///   - x: skewness factor in the horizontal direction, from the origin. This is a dimensionless number.
  ///   - y: skewness factor in the vertical direction, from the origin. This is a dimensionless number.
  /// - Returns: A new affine transformation matrix. That is, t’ = t1*t2.
  func skewedBy(x: CGFloat, y: CGFloat) -> CGAffineTransform {
    concatenating(CGAffineTransform(skewX: x, y: y))
  }
 
}
