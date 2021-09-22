//
//  IsoscelesTriangle.swift
//  
//
//  Created by nutterfi on 9/22/21.
//

import SwiftUI

public struct IsoscelesTriangle: Shape {
  
  var inset: CGFloat = .zero
  
  public init() {}

  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.move(to: CGPoint(x: aRect.midX, y: aRect.minY))
      path.addLine(to: CGPoint(x: aRect.maxX, y: aRect.maxY))
      path.addLine(to: CGPoint(x: aRect.minX, y: aRect.maxY))
      path.closeSubpath()
    }
  }
}

extension IsoscelesTriangle: InsettableShape {
  
  public func inset(by amount: CGFloat) -> some InsettableShape {
    var triangle = self
    triangle.inset += amount
    return triangle
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
          .inset(by: inset)
          .border(.purple, width: 10)
        }
      }
      
      
    }
}
