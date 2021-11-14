//
//  CGPoint+Extensions.swift
//  
//
//  Created by nutterfi on 11/14/21.
//

import CoreGraphics

public extension CGPoint {
  func offsetBy(x: CGFloat, y: CGFloat) -> CGPoint {
    CGPoint(x: self.x + x, y: self.y + y)
  }
}

public func -(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  CGPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
}

public func +(lhs: CGPoint, rhs: CGPoint) -> CGPoint {
  CGPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
}
