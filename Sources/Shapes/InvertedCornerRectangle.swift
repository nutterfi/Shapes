//
//  InvertedCornerRectangle.swift
//
//  Created by nutterfi on 3/18/21.
//

import SwiftUI

public struct InvertedCornerRectangle: Shape {
  
  public var cornerRadius: CGFloat = 0.0
  
  public init(cornerRadius: CGFloat) {
    self.cornerRadius = cornerRadius
  }
  
  public func path(in rect: CGRect) -> Path {
    
    Path { path in
      // starting point
      path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
      
      path.addArc(center: CGPoint(x: rect.minX, y: rect.minY), radius: cornerRadius, startAngle: .init(radians: .pi / 2), endAngle: .zero, clockwise: true)
      
      // draw line to the right
      path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
      
      path.addArc(center: CGPoint(x: rect.maxX, y: rect.minY), radius: cornerRadius, startAngle: .init(radians: .pi), endAngle: .init(radians: .pi / 2), clockwise: true)
      
      // draw line down
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
      
      path.addArc(center: CGPoint(x: rect.maxX, y: rect.maxY), radius: cornerRadius, startAngle: .init(radians: -.pi / 2), endAngle: .init(radians: .pi), clockwise: true)
      
      // draw line left
      path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
      
      path.addArc(center: CGPoint(x: rect.minX, y: rect.maxY), radius: cornerRadius, startAngle: .zero, endAngle: .init(radians: -.pi / 2), clockwise: true)
      
      // draw line up
      path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
      path.closeSubpath()
    }
  }
}

struct InvertedCornerRectangle_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        InvertedCornerRectangle(cornerRadius: 20)
          .stroke(Color.purple, lineWidth: 10)

        InvertedCornerRectangle(cornerRadius: 20)
          .inset(amount: 30)
          .stroke(Color.purple, lineWidth: 10)

      }
      .frame(width: 200, height: 300)

    }
}
