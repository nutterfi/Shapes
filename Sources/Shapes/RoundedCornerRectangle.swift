//
//  RoundedCornerRectangle.swift
//
//  Created by nutterfi on 10/12/21.
//

import SwiftUI

public struct RoundedCornerRectangle: NFiShape {
  
  public enum Corner {
    case topLeft, topRight, bottomLeft, bottomRight
  }
  
  public var corners: [Corner]
  public var inset: CGFloat = .zero
  
  public var cornerRadius: CGFloat
  
  public init(cornerRadius: CGFloat, corners: [Corner] = []) {
    self.cornerRadius = cornerRadius
    self.corners = corners
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    
    return Path { path in
      // starting point
      path.move(to: CGPoint(x: insetRect.minX, y: insetRect.minY + cornerRadius))
      
      if corners.contains(.topLeft) {
        path.addArc(center: CGPoint(x: insetRect.minX + cornerRadius, y: insetRect.minY + cornerRadius), radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi), endAngle: .init(radians: -.pi / 2), clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.minY))
      }
      
      // draw line to the right
      path.addLine(to: CGPoint(x: insetRect.maxX - CGFloat(cornerRadius), y: insetRect.minY))
      
      if corners.contains(.topRight) {
        
        path.addArc(center: CGPoint(x: insetRect.maxX - cornerRadius, y: insetRect.minY + cornerRadius), radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi), endAngle: .zero, clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.minY))
      }
      
      // draw line down
      path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY - CGFloat(cornerRadius)))
      
      if corners.contains(.bottomRight) {
        path.addArc(center: CGPoint(x: insetRect.maxX - cornerRadius, y: insetRect.maxY - cornerRadius), radius: CGFloat(cornerRadius), startAngle: .zero, endAngle: .init(radians: .pi / 2), clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY))
      }
      
      // draw line left
      path.addLine(to: CGPoint(x: insetRect.minX + CGFloat(cornerRadius), y: insetRect.maxY))
      
      if corners.contains(.bottomLeft) {
        path.addArc(center: CGPoint(x: insetRect.minX + cornerRadius, y: insetRect.maxY - cornerRadius), radius: CGFloat(cornerRadius), startAngle: .init(radians: .pi / 2), endAngle: .init(radians: .pi), clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.maxY))
      }
      
      // draw line up
      path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.minY + cornerRadius))
      path.closeSubpath()
    }
  }
  
}

struct RoundedCornerRectangle_Previews: PreviewProvider {
  static var previews: some View {
    RoundedCornerRectangle(cornerRadius: 32, corners: [.topLeft, .topRight, .bottomRight])
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
