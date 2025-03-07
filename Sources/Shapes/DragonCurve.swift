//
//  DragonCurve.swift
//  
//
//  Created by nutterfi on 12/21/21.
//

import SwiftUI
/**
 Dragon Curve is a type of fractal pattern. Here is an implementation of the Heighway Dragon Curve:
 
 For each step, add R then reversed+swapped of previous step
 1: R
 2: R + R + [L]
    reversed + swapped is LRR (reversed) -> RLL (swapped)
 3: RRL + R + [RLL]
 4: RRLRRLL + R + [RRLLRLL]
 */
public struct DragonCurve: Shape {
  public var steps: Int = 4
  public var angleDegrees: Int = 90
  
  public init(steps: Int = 4, angleDegrees: Int = 60) {
    self.steps = steps
    self.angleDegrees = angleDegrees
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      var elements = ""
      
      // 'R' == 0
      // 'L' == 1
      // for each step
      path.move(to: rect.midXY)
      for _ in 0..<steps {
        let reversed = String(elements.reversed())
        let swapped = reversed.map { element in
          return element == "R" ? "L" : "R"
        }
        elements = elements + "R" + swapped.joined(separator: "")
      }
      
      var totalAngle: Angle = .zero
      
      elements.forEach { element in
        let factor: Int = element == "R" ? 1 : -1
        let turnAngle = angleDegrees * factor
        
        totalAngle += .degrees(Double(turnAngle))
        let x = cos(totalAngle.radians)
        let y = sin(totalAngle.radians)
        path.addLine(to: CGPoint(x: x + path.currentPoint!.x, y: y + path.currentPoint!.y))
      }
      
      let bounding = path.boundingRect
      
      path = path
        .offsetBy(dx: rect.midX - bounding.midX, dy: rect.midY - bounding.midY)
        .scale(rect.breadth / bounding.length)
        .path(in: rect)
    }
  }
}

struct DragonCurve_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      DragonCurve(steps: 8)
      .stroke(Color.purple)
      .frame(width: 256, height: 128)
      .border(Color.purple)
      
      DragonCurve(steps: 8)
      .stroke(Color.purple)
      .frame(width: 128, height: 128)
      .border(Color.purple)
      
      DragonCurve(steps: 8)
      .stroke(Color.purple)
      .frame(width: 64, height: 256)
      .border(Color.purple)
    }
  }
}
