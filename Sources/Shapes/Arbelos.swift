//
//  Arbelos.swift
//  Shapes
//
//  Created by nutterfi on 7/16/25.
//

import SwiftUI

public struct Arbelos: Shape {
  /// the relative horizontal position bounding the two smaller circles
  public var xPosition: CGFloat
  public init(xPosition: CGFloat = 0.65) {
    self.xPosition = xPosition.clamped(min: 0, max: 1)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let dim = rect.breadth
      let radius = dim * 0.5
      let center = rect.midXY
      
      // outer semicircle
      path.addArc(center: center, radius: dim * 0.5, startAngle: .radians(.pi), endAngle: .zero, clockwise: false)
      
      // calculate positions and centers of smaller semis
      
      let point = CGPoint(x: rect.midX - radius + xPosition * dim, y: rect.midY)
      
      let radius1 = (1 - xPosition) * 0.5 * dim
      let center1 = point.offsetBy(dx: radius1, dy: 0)
      
      path.addArc(center: center1, radius: radius1, startAngle: .zero, endAngle: .radians(.pi), clockwise: true)
      
      let radius2 = xPosition * 0.5 * dim
      let center2 = point.offsetBy(dx: -radius2, dy: 0)
      
      path.addArc(center: center2, radius: radius2, startAngle: .zero, endAngle: .radians(.pi), clockwise: true)
    }
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
  @Previewable @State var xPosition: CGFloat = 0.65
  VStack {
    Slider(value: $xPosition)
    
    Arbelos(xPosition: xPosition)
  }
  .padding()
}
