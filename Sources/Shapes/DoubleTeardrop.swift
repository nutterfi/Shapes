//
//  DoubleTeardrop.swift
//
//  Created by nutterfi on 4/20/21.
//

import SwiftUI

public struct DoubleTeardrop: Shape {
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let midPoint = CGPoint(x: rect.midX, y: rect.midY)
      path.move(to: .zero)
      path.addLine(to: CGPoint(x: rect.midX, y: 0))
      path.addArc(center: midPoint, radius: rect.midY, startAngle: Angle(radians: -.pi / 2), endAngle: .zero, clockwise: false)
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
      path.addLine(to: CGPoint(x: rect.midX, y: rect.maxY))
      path.addArc(center: midPoint, radius: rect.midY, startAngle: Angle(radians: .pi / 2), endAngle: Angle(radians: .pi), clockwise: false)
    }
  }
  
}

struct DoubleTeardrop_Previews: PreviewProvider {
    static var previews: some View {
        DoubleTeardrop()
          .frame(width: 100, height: 100)
    }
}
