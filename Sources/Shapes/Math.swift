//
//  Math.swift
//  
//
//  Created by nutterfi on 12/30/21.
//

import CoreGraphics

public struct Math {
  
  /// builds a damped sin wave
  public static func dampedOscillator(
    points: Int = 1000,
    sampleRate: CGFloat = 1000,
    phase: CGFloat = .zero, // radians
    dampingFactor: CGFloat = 0
  ) -> [CGFloat] {
    var data: [CGFloat] = []
    let interval = 1.0 / sampleRate
    
    for (index, _) in Array(0...points).enumerated() {
      let floatIndex = CGFloat(index)
      let damping = exp(-dampingFactor * floatIndex)
      
      data.append(damping * cos(2 * .pi * (interval * floatIndex + phase)))
    }
    return data
  }
  
}
