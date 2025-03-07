//
//  Halftone.swift
//
//
//  Created by nutterfi on 11/14/23.
//

import SwiftUI
/// Nice-to-haves
/// general pattern parameters
extension WIP {
  public struct Halftone: Shape {
    public var radius: Double // radius
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
            
            let item = CGRect(origin: origin, size: CGSize(width: edge, height: edge))
            
            rects.append(item)
          }
        }
        
        rects.forEach { frame in
          let otherFactor = 0.001555
          let rFactor = min(1.4, frame.origin.x * otherFactor)
          let cFactor = min(1.4, frame.origin.y * otherFactor)
          
          path.addPath(
            Circle()
              .inset(by: spacing * rFactor * cFactor)
              .path(in: frame)
            
          )
        }
      }
    }
  }
}

#Preview {
  if #available(iOS 16.0, *) {
    WIP.Halftone()
//      .clipShape(Salinon())
      .foregroundStyle(LinearGradient(colors: [.blue, .green, .black], startPoint: .top, endPoint: .bottom))
    //    .stroke()
      .padding()
  } else {
    // Fallback on earlier versions
    Circle()
  }
}
