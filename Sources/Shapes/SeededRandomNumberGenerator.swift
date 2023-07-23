//
//  SeededRandomNumberGenerator.swift
//
//
//  Created by nutterfi on 7/22/23.
//

import Foundation

public struct SeededRandomNumberGenerator: RandomNumberGenerator {
  let seed: Int
  
  public init(seed: Int = 0) {
    self.seed = seed
    srand48(seed)
  }
  
  public mutating func next() -> UInt64 {
    return UInt64(drand48() * Double(UInt64.max))
  }
  
}

public extension SeededRandomNumberGenerator {
  mutating func randomPoint() -> CGPoint {
    let x = CGFloat.random(in: 0...1, using: &self)
    let y = CGFloat.random(in: 0...1, using: &self)
    return CGPoint(x: x, y: y)
  }
}
