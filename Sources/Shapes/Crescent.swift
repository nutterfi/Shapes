//
//  Crescent.swift
//  
//  Created by nutterfi on 4/23/21.
//

import SwiftUI

// FIXME: This is more like a pseudo-crescent shape. Maybe even a boomerang? I'd like to add the ability to modify the curves
public struct Crescent: Shape {

  /// The offset of the circle that creates the crescent effect
  public var offset: UnitPoint
  
  /// Creates a new crescent shape.
  public init(offset: UnitPoint = UnitPoint(x: 0.2, y: 0)) {
    self.offset = offset
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: CGPoint(x: rect.minX, y: rect.minY))
      path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY), control: rect.midXY)
      path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.minY), control: CGPoint(x: rect.maxX, y: rect.midY))
      path.closeSubpath()
    }
  }
}

struct CrescentView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Crescent().fill(Color.purple)
        Crescent().inset(amount: 32)
      }
      .frame(width: 256, height: 256)
      .border(Color.black)
    }
}
