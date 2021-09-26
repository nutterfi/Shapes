//
//  DoubleTeardrop.swift
//
//  Created by nutterfi on 4/20/21.
//

import SwiftUI

public struct DoubleTeardrop: NFiShape {
  public var inset: CGFloat = .zero
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)

    return Path { path in
      let midPoint = CGPoint(x: aRect.midX, y: aRect.midY)
      
      path.move(to: CGPoint(x: aRect.minX, y: aRect.minY))
      path.addLine(to: CGPoint(x: aRect.midX, y: aRect.minY))
      path.addArc(center: midPoint, radius: aRect.height / 2, startAngle: Angle(radians: -.pi / 2), endAngle: .zero, clockwise: false)
      path.addLine(to: CGPoint(x: aRect.maxX, y: aRect.maxY))
      path.addLine(to: CGPoint(x: aRect.midX, y: aRect.maxY))
      path.addArc(center: midPoint, radius: aRect.height / 2, startAngle: Angle(radians: .pi / 2), endAngle: Angle(radians: .pi), clockwise: false)
      path.closeSubpath()
    }
  }
  
}

struct DoubleTeardrop_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        DoubleTeardrop().fill(Color.purple)
        DoubleTeardrop()
          .inset(by: 32)
          .stroke()
      }
      .frame(width: 128, height: 128)
    }
}
