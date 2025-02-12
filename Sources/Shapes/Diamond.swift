//
//  Diamond.swift
//
//  Created by nutterfi on 2/6/21.
//

import SwiftUI

public struct Diamond: Shape {
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    Kite(pointRatio: 0.5).path(in: rect)
  }
  
  // MARK: - Deprecations
  
  /// The inset amount of the polygon
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
  
}

struct Diamond_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Diamond()
      .foregroundStyle(.green)
      Diamond().inset(amount: 64)
        .stroke()
    }
    .frame(width: 256, height: 256)
  }
}
