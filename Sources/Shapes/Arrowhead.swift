//
//  Arrow.swift
//
//  Created by nutterfi on 4/27/21.
//

import SwiftUI

public struct Arrowhead: Shape {
  
  // normalized
  public var tipPoint: CGPoint
  public var midPoint: CGPoint
  public var controlPointRight: CGPoint
  public var controlPointLeft: CGPoint
  
  public init(tipPoint: CGPoint = CGPoint(x: 0.5, y: 0),
              midPoint: CGPoint = CGPoint(x: 0.5, y: 0.75),
              controlPointRight: CGPoint = CGPoint(x: 0.75, y: 0.5),
              controlPointLeft: CGPoint = CGPoint(x: 0.25, y: 0.5)
              ) {
    self.tipPoint = tipPoint
    self.midPoint = midPoint
    self.controlPointLeft = controlPointLeft
    self.controlPointRight = controlPointRight
  }

  public func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: tipPoint.x * rect.width, y: tipPoint.y * rect.height))
      
      path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                        control: CGPoint(x: controlPointRight.x * rect.width, y: controlPointRight.y * rect.height))
      
      path.addQuadCurve(to: CGPoint(x: midPoint.x * rect.width, y: midPoint.y * rect.height),
                        control: CGPoint(x: rect.maxX, y: rect.maxY))
      
      path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                        control: CGPoint(x: rect.minX, y: rect.height))
      
      path.addQuadCurve(to: CGPoint(x: tipPoint.x * rect.width, y: tipPoint.y * rect.height),
                        control: CGPoint(x: controlPointLeft.x * rect.width, y: controlPointLeft.y * rect.height))
    }
  }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
      Arrowhead(tipPoint: CGPoint(x: 0.5, y: 0),
            midPoint: CGPoint(x: 0.5, y: 0.75))
          .fill(Color.orange)
          .frame(width: 200, height: 200)
          .border(Color.purple)
    }
}
