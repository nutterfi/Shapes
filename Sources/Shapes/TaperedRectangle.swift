//
//  TaperedRect.swift
//
//  Created by nutterfi on 2/16/21.
//

import SwiftUI

public struct TaperedRectangle: Shape, Polygon {
  public var sides: Int = 6
  public var taper: CGFloat = 0
  
  public init(taper: CGFloat) {
    self.taper = taper
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    
    let value = min(abs(taper), rect.midX)
    
    return [
      CGPoint(x: rect.minX, y: rect.midY),
      CGPoint(x: rect.minX + value, y: rect.minY),
      CGPoint(x: rect.maxX - value, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.midY),
      CGPoint(x: rect.maxX - value, y: rect.maxY),
      CGPoint(x: rect.minX + value, y: rect.maxY)
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect))
      path.closeSubpath()
    }
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

@available(*, deprecated, message: "TaperedRect has been renamed to TaperedRectangle")
public typealias TaperedRect = TaperedRectangle

struct TaperedRect_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        TaperedRectangle(taper: 20)
          .frame(width:200, height:50)
        .foregroundStyle(.green)
        
        TaperedRectangle(taper: 20)
          .inset(amount: 20)
          .frame(width: 200, height: 50)
        .foregroundStyle(.red)
      }
    }
}

