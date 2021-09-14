//
//  ReuleauxPolygon.swift
//
//  Created by nutterfi on 9/7/21.
//

import SwiftUI

/**
 A curve of constant width made up of circular arcs of constant radius. This implementation assumes odd-number sided regular polygons
 */
public struct ReuleauxPolygon: Polygon {
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    ConvexPolygon(sides: sides).vertices(in: rect)
  }
  
  /// must be odd
  public var sides: Int
  
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
      ReuleauxPolygon(sides: 5)
        .stroke()
    }
}
