//
//  RightKite.swift
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

/// A kite where points are placed along a circle
public struct RightKite: Polygon {
  public var inset: CGFloat = .zero
  
  public var sides: Int = 4
  
  /// Ratio between 0 and pi for the placement of the kite points around the circle
  public var pointRatio: CGFloat = 0.5
  
  public init(pointRatio: CGFloat) {
    self.pointRatio = pointRatio
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    
    let theta = .pi * pointRatio
    let point = CGPoint(x: origin.x + r * cos(theta), y: origin.y + r * sin(theta))
    let pointPrime = CGPoint(x: origin.x + r * cos(theta), y: origin.y - r * sin(theta))
    
    return [
      CGPoint(x: rect.maxX, y: rect.midY),
      point,
      CGPoint(x: rect.minX, y: rect.midY),
      pointPrime
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.addLines(vertices(in: aRect))
      path.closeSubpath()
    }
    .rotation(.degrees(-90)).path(in: aRect)
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
      RightKite(pointRatio: 0.5)
        .inset(by: 50)
      Circle()
        .inset(by: 50)
        .stroke()

    }
    .frame(width: 256, height: 256)
  }
}
