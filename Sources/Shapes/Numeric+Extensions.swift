//
//  Numeric+Extensions.swift
//  
//
//  Created by nutterfi on 12/3/21.
//

import Foundation

public extension Numeric {
  func clamped<T: Comparable>(min minimum: T, max maximum: T) -> T {
    min(max(minimum, self as! T), maximum)
  }
  
  func clamped<T: Comparable>(to range: ClosedRange<T>) -> T {
    return min(max(range.lowerBound, self as! T), range.upperBound)
  }
}
