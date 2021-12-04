//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 10/12/21.
//

import SwiftUI

public struct Lens: NFiShape {
  public var inset: CGFloat = .zero
  public var curveFactor: CGFloat  // clamped between [0, 1]
  
  public init(_ curveFactor: CGFloat = 0.5) {
    self.curveFactor = curveFactor.clamped(to: 0...1)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      
      path.move(
        to: CGPoint(
          x: insetRect.midX,
          y: insetRect.minY
        )
      )
      
      path.addQuadCurve(
        to: CGPoint(
          x: insetRect.midX,
          y: insetRect.maxY
        ),
        control: CGPoint(
          x: insetRect.maxX + insetRect.width * 0.5 - curveFactor * insetRect.width,
          y: insetRect.midY
        )
      )
      
      path.addQuadCurve(
        to: CGPoint(
          x: insetRect.midX,
          y: insetRect.minY
        ),
        control: CGPoint(
          x: insetRect.minX - insetRect.width * 0.5 + curveFactor * insetRect.width,
          y: insetRect.midY
        )
      )
      
      path.closeSubpath()
    }
  }
    
}

struct LensDemo: View {
  @State private var value: CGFloat = 0.5
  
  var body: some View {
    VStack {
      Slider(value: $value)
      Spacer()
      Lens(value)
        .stroke(lineWidth: 10)
        .frame(width: 300, height: 300)
        .border(Color.purple)
      Spacer()
    }
  }
}

struct Lens_Previews: PreviewProvider {
  static var previews: some View {
    LensDemo()
  }
}
