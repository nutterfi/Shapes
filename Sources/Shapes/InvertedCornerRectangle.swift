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
    let width = rect.width
    let height = rect.height
    
    return Path { path in
      // starting point
      path.move(to: CGPoint(x: 0.0, y: cornerRadius))
      
      path.addArc(center: .zero, radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi / 2), endAngle: .zero, clockwise: true)
      
      // draw line to the right
      path.addLine(to: CGPoint(x: width - CGFloat(cornerRadius), y: 0))
      
      path.addArc(center: CGPoint(x: width, y: 0), radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi), endAngle: .init(radians: .pi / 2), clockwise: true)
      
      // draw line down
      path.addLine(to: CGPoint(x: width, y: height - CGFloat(cornerRadius)))
      
      path.addArc(center: CGPoint(x: width, y: height), radius: CGFloat(cornerRadius), startAngle: .init(radians: -.pi / 2), endAngle: .init(radians: .pi), clockwise: true)
      
      // draw line left
      path.addLine(to: CGPoint(x: CGFloat(cornerRadius), y: height))
      
      path.addArc(center: CGPoint(x: 0, y: height), radius: CGFloat(cornerRadius), startAngle: .zero, endAngle: .init(radians: -.pi / 2), clockwise: true)
      
      // draw line up
      path.addLine(to: CGPoint(x: 0, y: cornerRadius))
      path.closeSubpath()
    }
  }
}

struct InvertedCornerRectangle_Previews: PreviewProvider {
    static var previews: some View {
        InvertedCornerRectangle(cornerRadius: 20)
          .stroke(Color.purple, lineWidth: 10)
          .frame(width: 200, height: 300)
    }
}
