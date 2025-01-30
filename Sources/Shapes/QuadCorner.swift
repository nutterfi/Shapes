//
//  QuadCorner.swift
//  
//
//  Created by nutterfi on 9/21/21.
//

import SwiftUI

public struct QuadCorner: Shape {
  public var cornerRadius: CGFloat = 0.0
  
  public init(cornerRadius: CGFloat) {
    self.cornerRadius = cornerRadius
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      // starting point
      path.move(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
      
      path.addLine(to: CGPoint(x: rect.minX, y: rect.minY))
      
      path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
      
      path.move(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
      
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.minY + cornerRadius))
      
      path.move(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
      
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY))
      
      path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
      
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY - cornerRadius))
    }
  }
  
  // MARK: - Deprecations
  
  /// The inset amount of the shape
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
}

struct QuadCorner_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        QuadCorner(cornerRadius: 50)
          .stroke(Color.purple)
        QuadCorner(cornerRadius: 50)
          .inset(amount: 20)
          .stroke(Color.purple)
      }
      .frame(width: 256, height: 512)
    }
}
