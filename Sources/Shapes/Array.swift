//
//  Array.swift
//  Shapes
//
//  Created by nutterfi on 2/10/25.
//


import SwiftUI

/// Allows arrays that conform to AdditiveArithmetic to be added and subtracted together.
extension Array where Element: AdditiveArithmetic {
  public static func - (lhs: Array<Element>, rhs: Array<Element>) -> Array<Element> {
    let length: Int = Swift.min(lhs.count, rhs.count)
    
    return (0..<length).map({lhs[$0] - rhs[$0]})
  }
  
  public static func + (lhs: Array<Element>, rhs: Array<Element>) -> Array<Element> {
    let length: Int = Swift.min(lhs.count, rhs.count)
    
    return (0..<length).map({lhs[$0] + rhs[$0]})
  }
}

/// Allows arrays that conform to VectorArithmetic to perform multiply operations.
extension Array where Element: VectorArithmetic {
  
  public mutating func scale(by rhs: Double) {
    self = self.map {
      var element = $0
      element.scale(by: rhs)
      return element
    }
  }
  
  public var magnitudeSquared: Double {
    let array: [Double] = self.map { $0.magnitudeSquared }
    return array.reduce(0, +)
  }
  
}
