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
    let width = rect.width
    let height = rect.height
    
    return Path { path in
      // starting point
      path.move(to: CGPoint(x: 0.0, y: cornerRadius))
      
      path.addLine(to: .zero)
      
      path.addLine(to: CGPoint(x: cornerRadius, y: 0))
      
      path.move(to: CGPoint(x: width - cornerRadius, y: 0))
      
      path.addLine(to: CGPoint(x: width, y: 0))
      path.addLine(to: CGPoint(x: width, y: cornerRadius))
      
      path.move(to: CGPoint(x: width, y: height - cornerRadius))
      
      path.addLine(to: CGPoint(x: width, y: height))
      path.addLine(to: CGPoint(x: width - cornerRadius, y: height))
      
      path.move(to: CGPoint(x: cornerRadius, y: height))
      
      path.addLine(to: CGPoint(x: 0, y: height))
      path.addLine(to: CGPoint(x: 0, y: height - cornerRadius))
    }
  }
}

struct QuadCorner_Previews: PreviewProvider {
    static var previews: some View {
      QuadCorner(cornerRadius: 50)
        .stroke(Color.purple)
        .frame(width: 256, height: 512)
    }
}
