//
//  Teardrop.swift
//
//  Created by nutterfi on 4/22/21.
//

import SwiftUI

public struct Teardrop: Shape {
  // TODO: Consider using a CGPoint instead for better customization
  public var variation: CGFloat
  
  public init(_ variation: CGFloat = 0.5) {
    self.variation = max(0, min(variation, 1))
  }
  
  public func path(in rect: CGRect) -> Path {
    let dim = min(rect.width, rect.height)
    let midPoint = CGPoint(x: rect.midX, y: rect.midY)
    let origin = CGPoint(x: rect.midX, y: 0)
    return Path { path in
      path.move(to: origin)
      
      path.addQuadCurve(to: CGPoint(x: rect.midX + dim * 0.5, y: rect.midY), control: CGPoint(x: rect.midX + dim * 0.5, y: rect.midY * variation))
      
      path.addArc(center: midPoint, radius: dim * 0.5, startAngle: .zero, endAngle: Angle(radians: .pi), clockwise: false)
      
      path.addQuadCurve(to: origin, control: CGPoint(x: rect.midX - dim * 0.5, y: rect.midY * variation))
      
      path.addLine(to: CGPoint(x: rect.midX, y: 0))
      path.closeSubpath()
    }
  }
  
}

struct Teardrop_Previews: PreviewProvider {
    static var previews: some View {
      Teardrop()
          .rotation(Angle(radians: .pi))
          .stroke(Color.purple)
          .frame(width: 100, height: 180)
          .padding()
          .border(Color.black)
    }
}
