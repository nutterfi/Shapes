//
//  RightKite.swift
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

/// A kite where points are placed along a circle
public struct RightKite: Shape {
  /// Ratio between 0 and pi for the placement of the kite points around the circle
  public var pointRatio: CGFloat = 0.5
  
  public init(pointRatio: CGFloat) {
    self.pointRatio = pointRatio
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let r = min(rect.size.width, rect.size.height) / 2
      let origin = CGPoint(x: rect.midX, y: rect.midY)
      
      let theta = .pi * pointRatio
      let point = CGPoint(x: origin.x + r * cos(theta), y: origin.y + r * sin(theta))
      let pointPrime = CGPoint(x: origin.x + r * cos(theta), y: origin.y - r * sin(theta))
      
      
      path.move(to: CGPoint(x: rect.maxX, y: rect.midY))
      path.addLine(to: point)
      path.addLine(to: CGPoint(x: rect.minX, y: rect.midY))
      path.addLine(to: pointPrime)
      path.closeSubpath()
    }.rotation(.degrees(-90)).path(in: rect)
  }
  
}

extension RightKite: Animatable {
  public var animatableData: CGFloat {
    get {
      pointRatio
    }
    set {
      pointRatio = newValue
    }
  }
}

struct RightKite_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Circle().stroke()
      RightKite(pointRatio: 0.35)
    }
    .frame(width: 256, height: 256)
  }
}
