//
//  Crescent.swift
//  
//  Created by nutterfi on 4/23/21.
//

import SwiftUI

// FIXME: This is more like a pseudo-crescent shape. Maybe even a boomerang? I'd like to add the ability to modify the curves
public struct Crescent: NFiShape {
  public var inset: CGFloat = .zero
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.move(to: CGPoint(x: aRect.minX, y: aRect.minY))
      path.addQuadCurve(to: CGPoint(x: aRect.minX, y: aRect.maxY), control: CGPoint(x: aRect.midX, y: aRect.midY))
      path.addQuadCurve(to: CGPoint(x: aRect.minX, y: aRect.minY), control: CGPoint(x: aRect.maxX, y: aRect.midY))
      path.closeSubpath()
    }
  }
  
}

struct CrescentView_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Crescent().fill(Color.purple)
        Crescent().inset(by: 32)
      }
      .frame(width: 256, height: 256)
      .border(Color.black)
    }
}
