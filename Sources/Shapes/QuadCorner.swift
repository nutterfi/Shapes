//
//  QuadCorner.swift
//  
//
//  Created by nutterfi on 9/21/21.
//

import SwiftUI

public struct QuadCorner: NFiShape {
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
      
      path.addLine(to: CGPoint(x: aRect.minX, y: aRect.minY))
      
      path.addLine(to: CGPoint(x: aRect.minX + cornerRadius, y: aRect.minY))
      
      path.move(to: CGPoint(x: aRect.maxX - cornerRadius, y: aRect.minY))
      
      path.addLine(to: CGPoint(x: aRect.maxX, y: aRect.minY))
      path.addLine(to: CGPoint(x: aRect.maxX, y: aRect.minY + cornerRadius))
      
      path.move(to: CGPoint(x: aRect.maxX, y: aRect.maxY - cornerRadius))
      
      path.addLine(to: CGPoint(x: aRect.maxX, y: aRect.maxY))
      path.addLine(to: CGPoint(x: aRect.maxX - cornerRadius, y: aRect.maxY))
      
      path.move(to: CGPoint(x: aRect.minX + cornerRadius, y: aRect.maxY))
      
      path.addLine(to: CGPoint(x: aRect.minX, y: aRect.maxY))
      path.addLine(to: CGPoint(x: aRect.minX, y: aRect.maxY - cornerRadius))
    }
  }
}

struct QuadCorner_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        QuadCorner(cornerRadius: 50)
          .stroke(Color.purple)
        QuadCorner(cornerRadius: 50)
          .inset(by: 20)
          .stroke(Color.purple)
      }
      .frame(width: 256, height: 512)
    }
}
