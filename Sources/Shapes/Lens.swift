//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 10/12/21.
//

import SwiftUI

public struct Lens: Shape {
  public var curveFactor: CGFloat  // clamped between [0, 1]
  
  public init(_ curveFactor: CGFloat = 0.5) {
    self.curveFactor = curveFactor.clamped(to: 0...1)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(
        to: CGPoint(
          x: rect.midX,
          y: rect.minY
        )
      )
      
      path.addQuadCurve(
        to: CGPoint(
          x: rect.midX,
          y: rect.maxY
        ),
        control: CGPoint(
          x: rect.maxX + rect.width * 0.5 - curveFactor * rect.width,
          y: rect.midY
        )
      )
      
      path.addQuadCurve(
        to: CGPoint(
          x: rect.midX,
          y: rect.minY
        ),
        control: CGPoint(
          x: rect.minX - rect.width * 0.5 + curveFactor * rect.width,
          y: rect.midY
        )
      )
      
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
