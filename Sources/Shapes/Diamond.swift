//
//  Diamond.swift
//
//  Created by nutterfi on 2/6/21.
//

import SwiftUI

public struct Diamond: NFiShape {
  public var inset: CGFloat = .zero
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    Kite(pointRatio: 0.5).path(in: rect.insetBy(dx: inset, dy: inset))
  }
  
}

struct Diamond_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Diamond()
      .foregroundColor(.green)
      Diamond().inset(by: 64)
        .stroke()
    }
    .frame(width: 256, height: 256)
  }
}
