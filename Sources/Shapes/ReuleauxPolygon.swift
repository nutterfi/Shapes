//
//  ReuleauxPolygon.swift
//
//  Created by nutterfi on 9/7/21.
//

import SwiftUI

// Good job Chat
public struct Reuleaux {
  public static let triangle = ReuleauxPolygon(sides: 3)
  public static let pentagon = ReuleauxPolygon(sides: 5)
  public static let septagon = ReuleauxPolygon(sides: 7)
  public static let nonagon = ReuleauxPolygon(sides: 9)
}

/**
 A curve of constant width made up of circular arcs of constant radius. This implementation assumes odd-number sided regular polygons
 */
public struct ReuleauxPolygon: Shape, Polygon {
    
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
      
      // start angle at first position, accounting for N pointing origin
      let a0 = .pi - (.pi / (2.0 * CGFloat(sides))) - .pi / 2
      
      // the arc is drawn for each side of the polygon where the center is the opposite point
      for i in 0..<sides {
        let startAngle = a0 + CGFloat(i) * arc
        path.addRelativeArc(center: points[i], radius: r, startAngle: .radians(startAngle), delta: .radians(delta))
      }
      path.closeSubpath()
      
    }
  }
    
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  // MARK: - Deprecations
  
  /// The inset amount of the shape
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
}

struct ReuleauxPolygon_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Reuleaux.triangle
          .stroke()
        Reuleaux.triangle.inset(amount: 10)
          .stroke()
        
        let vertices = Reuleaux.triangle.vertices(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        ForEach(0..<vertices.count, id: \.self) { index in
          let vertex = vertices[index]
          Circle().frame(width:10).offset(x: -128 + vertex.x, y: -128 + vertex.y)
        }
      }
      .frame(width: 256, height: 256)
      .border(Color.black)
    }
}
