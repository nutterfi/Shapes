//
//  ReuleauxPolygon.swift
//
//  Created by nutterfi on 9/7/21.
//

import SwiftUI

// Good job Chat
public struct Reuleaux {
  static let triangle = ReuleauxPolygon(sides: 3)
  static let pentagon = ReuleauxPolygon(sides: 5)
  static let septagon = ReuleauxPolygon(sides: 7)
  static let nonagon = ReuleauxPolygon(sides: 9)
}

/**
 A curve of constant width made up of circular arcs of constant radius. This implementation assumes odd-number sided regular polygons
 */
public struct ReuleauxPolygon: Polygon {
  
  public var inset: CGFloat = 0
  
  /// Should be odd. Undefined shape for even-sided cases
  public var sides: Int
  
  public init(sides: Int) {
    self.sides = sides
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    ConvexPolygon(sides: sides).vertices(in: rect)
  }

  public func path(in rect: CGRect) -> Path {
    Path { path in
      let points = vertices(in: rect)
            
      // length from furthest points
      let dx = abs(points[(sides-1)/2].x - points[0].x)
      let dy = abs(points[(sides-1)/2].y - points[0].y)
      let r = sqrt(dx * dx + dy * dy)
      
      // arc from point to point on the unit circle
      let arc: CGFloat = 2 * .pi / CGFloat(sides)
      
      // arc length centered at first position
      let delta = .pi / CGFloat(sides)
      
      // start angle at first position
      let a0 = .pi - (.pi / (2.0 * CGFloat(sides)))
      
      // the arc is drawn for each side of the polygon where the center is the opposite point
      for i in 0..<sides {
        let startAngle = a0 + CGFloat(i) * arc
        path.addRelativeArc(center: points[i], radius: r, startAngle: .radians(startAngle), delta: .radians(delta))
      }
      path.closeSubpath()
      
    }
    .rotation(.degrees(-90)).path(in: rect)
  }
    
}

struct ReuleauxPolygon_Previews: PreviewProvider {
    static var previews: some View {
      Reuleaux.triangle
        .stroke()
    }
}
