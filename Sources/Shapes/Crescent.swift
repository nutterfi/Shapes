//
//  Crescent.swift
//  
//  Created by nutterfi on 4/23/21.
//

import SwiftUI

// FIXME: This is more like a pseudo-crescent shape. Maybe even a boomerang? I'd like to add the ability to modify the curves
public struct Crescent: Shape {
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: .zero)
      path.addQuadCurve(to: CGPoint(x: 0, y: rect.maxY), control: CGPoint(x: rect.midX, y: rect.midY))
      path.addQuadCurve(to: .zero, control: CGPoint(x: rect.maxX, y: rect.midY))
      path.closeSubpath()
    }
  }
  
}

struct CrescentView_Previews: PreviewProvider {
    static var previews: some View {
      Crescent()
        .frame(width: 100, height: 100)
    }
}
