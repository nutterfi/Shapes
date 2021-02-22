//
//  Diamond.swift
//
//  Created by nutterfi on 2/6/21.
//

import SwiftUI

public struct Diamond: Shape {
  public var pointRatio: CGFloat = 0.5
  
  public init(pointRatio: CGFloat) {
    self.pointRatio = pointRatio
  }
  
  public func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: rect.midX, y: 0))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * pointRatio))
      path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.height * pointRatio))
      path.closeSubpath()
    }
  }
  
}

struct Diamond_Previews: PreviewProvider {
    static var previews: some View {
      Diamond(pointRatio: 0.25)
        .frame(width:200, height:200)
        .foregroundColor(.green)
    }
}
