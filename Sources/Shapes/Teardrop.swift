//
//  Teardrop.swift
//
//  Created by nutterfi on 4/22/21.
//

import SwiftUI

public struct Teardrop: NFiShape {
  
  public var inset: CGFloat = .zero
  
  // TODO: Consider using a CGPoint instead for better customization
  // FIXME: Better usage of space
  public var variation: CGFloat
  
  public init(_ variation: CGFloat = 0.5) {
    self.variation = max(0, min(variation, 1))
  }
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    
    let dim = min(aRect.width, aRect.height)
    let midPoint = CGPoint(x: aRect.midX, y: aRect.midY)
    let origin = CGPoint(x: aRect.midX, y: aRect.minY)
    
    return Path { path in
      path.move(to: origin)
      
      path.addQuadCurve(to: CGPoint(x: aRect.midX + dim * 0.5, y: aRect.midY), control: CGPoint(x: aRect.midX + dim * 0.5, y: aRect.midY * variation))
      
      path.addArc(center: midPoint, radius: dim * 0.5, startAngle: .zero, endAngle: Angle(radians: .pi), clockwise: false)
      
      path.addQuadCurve(to: origin, control: CGPoint(x: aRect.midX - dim * 0.5, y: aRect.midY * variation))
      path.closeSubpath()
    }
  }
  
}

struct Teardrop_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Teardrop()
            .rotation(Angle(radians: .pi))
            .stroke(Color.purple)
        Teardrop()
          .inset(by: 32)
            .rotation(Angle(radians: .pi))
            .stroke(Color.purple)
      }
      .border(Color.black)
      .frame(width: 256, height: 512)
    }
}
