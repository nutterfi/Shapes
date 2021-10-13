//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 10/12/21.
//

import SwiftUI

// WIP - TODO: Allow user to draw towards minX and maxX
public struct Lens: NFiShape {
  public var inset: CGFloat = .zero
  public var controlRatio: CGFloat
  
  public init(_ controlRatio: CGFloat = 0) {
    self.controlRatio = controlRatio
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      path.move(to: CGPoint(x: insetRect.midX, y: insetRect.minY))
      path.addQuadCurve(to: CGPoint(x: insetRect.midX, y: insetRect.maxY), control: CGPoint(x: insetRect.maxX - controlRatio * insetRect.width, y: insetRect.midY))
      path.addQuadCurve(to: CGPoint(x: insetRect.midX, y: insetRect.minY), control: CGPoint(x: insetRect.minX + controlRatio * insetRect.width, y: insetRect.midY))
    }
  }
    
}

struct Lens_Previews: PreviewProvider {
  static var previews: some View {
    Lens()
      .stroke(Color.purple, lineWidth: 5)
      .frame(width: 256, height: 256)
      .border(Color.black)
  }
}
