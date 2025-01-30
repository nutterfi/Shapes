//
//  Quad.swift
//  
//
//  Created by nutterfi on 10/5/21.
//

import SwiftUI

public struct Quad: Shape, Polygon {
  public init() {}
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addRect(rect)
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
  
  // MARK: - Deprecations
  
  /// The inset amount of the shape
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
}

struct Quad_Previews: PreviewProvider {
    static var previews: some View {
      Quad()
    }
}
