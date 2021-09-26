//
//  InvertedCornerRectangle.swift
//
//  Created by nutterfi on 3/18/21.
//

import SwiftUI

public struct InvertedCornerRectangle: NFiShape {

  public var inset: CGFloat = .zero
  
  public var cornerRadius: CGFloat = 0.0
  
  public init(cornerRadius: CGFloat) {
    self.cornerRadius = cornerRadius
  }
  
  public func path(in rect: CGRect) -> Path {
    
    let aRect = rect.insetBy(dx: inset, dy: inset)
    
    return Path { path in
      // starting point
      path.move(to: CGPoint(x: aRect.minX, y: aRect.minY + cornerRadius))
      
      path.addArc(center: CGPoint(x: aRect.minX, y: aRect.minY), radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi / 2), endAngle: .zero, clockwise: true)
      
      // draw line to the right
      path.addLine(to: CGPoint(x: aRect.maxX - CGFloat(cornerRadius), y: aRect.minY))
      
      path.addArc(center: CGPoint(x: aRect.maxX, y: aRect.minY), radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi), endAngle: .init(radians: .pi / 2), clockwise: true)
      
      // draw line down
      path.addLine(to: CGPoint(x: aRect.maxX, y: aRect.maxY - CGFloat(cornerRadius)))
      
      path.addArc(center: CGPoint(x: aRect.maxX, y: aRect.maxY), radius: CGFloat(cornerRadius), startAngle: .init(radians: -.pi / 2), endAngle: .init(radians: .pi), clockwise: true)
      
      // draw line left
      path.addLine(to: CGPoint(x: aRect.minX + CGFloat(cornerRadius), y: aRect.maxY))
      
      path.addArc(center: CGPoint(x: aRect.minX, y: aRect.maxY), radius: CGFloat(cornerRadius), startAngle: .zero, endAngle: .init(radians: -.pi / 2), clockwise: true)
      
      // draw line up
      path.addLine(to: CGPoint(x: aRect.minX, y: aRect.minY + cornerRadius))
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
          .inset(by: 30)
          .stroke(Color.purple, lineWidth: 10)

      }
      .frame(width: 200, height: 300)

    }
}
