//
//  Quad.swift
//  
//
//  Created by nutterfi on 10/5/21.
//

import SwiftUI

public struct Quad: Polygon {
  public var inset: CGFloat = .zero
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addRect(rect.insetBy(dx: inset, dy: inset))
    }
  }
  
  public var sides: Int { return 4 }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    return [
      CGPoint(x: rect.minX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.maxY)
    ]
  }
}

struct Quad_Previews: PreviewProvider {
    static var previews: some View {
      Quad()
    }
}
