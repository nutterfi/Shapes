//
//  BenDayDot.swift
//  
//
//  Created by nutterfi on 11/14/23.
//

import SwiftUI

extension WIP {
  /// The BenDayDot is a style used in early printing mediums such as comic book art, which uses circles of different sizes and colors to produce a composite result.
  public struct BenDayDot: Shape {
    /// The radius of each dot
    public var radius: Double
    /// Spacing between each dot
    public var spacing: Double
    
    public init(radius: Double = 10, spacing: Double = 10) {
      self.radius = radius
      self.spacing = spacing
    }
    
    public func path(in rect: CGRect) -> Path {
      Path { path in
        /// subdivide into smaller CGRect instances with the input
        /// draw circles inside each of them
        let edge: Double = radius * 2 + spacing
        
        let columns = rect.width / edge
        let rows = rect.height / edge
        var rects = [CGRect]()
        
        for row in 0...Int(rows) {
          for column in 0...Int(columns) {
            let origin = CGPoint(
              x: rect.minX - spacing * 0.5 + CGFloat(column) * edge,
              y: rect.minY - spacing * 0.5 + CGFloat(row) * edge
            )
            
            let item = CGRect.square(origin: origin, size: edge)
            
            rects.append(item)
          }
        }
        
        rects.forEach { frame in
          path.addPath(
            Circle()
              .inset(by: spacing / 2)
              .path(in: frame)
            
          )
        }
      }
    }
  }
}

#Preview {
  ZStack {
    WIP.BenDayDot(
      radius: 50,
      spacing: 20
    )
    .foregroundStyle(Color(.magenta))
    
    
    WIP.BenDayDot(
      radius: 50,
      spacing: 20
    )
    .rotation(.degrees(25))
    .foregroundStyle(.cyan)
    
    WIP.BenDayDot(
      radius: 20,
      spacing: 100
    )
    .rotation(.degrees(45))
    .foregroundStyle(.yellow)
  }
  .scaleEffect(0.2)
  .clipShape(RightTriangle())
}
