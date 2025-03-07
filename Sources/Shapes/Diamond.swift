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
