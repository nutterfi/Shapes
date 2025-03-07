//
//  IsoscelesTriangle.swift
//  
//
//  Created by nutterfi on 9/22/21.
//

import SwiftUI

public struct IsoscelesTriangle: Shape, Polygon {
  public var sides: Int = 3
  
  public init() {}
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    [
      CGPoint(x: rect.midX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.maxY)
    ]
  }

  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect))
      path.closeSubpath()
    }
  }
}

struct IsoscelesTriangle_Previews: PreviewProvider {
    static var previews: some View {
      VStack(spacing: 0) {
        let inset: CGFloat = 90
        IsoscelesTriangle()
          .border(Color.purple)
        ZStack {
          Rectangle().inset(by: inset).stroke()
        IsoscelesTriangle()
          .inset(amount: inset)
          .border(.purple, width: 10)
        }
      }
      
      
    }
}
