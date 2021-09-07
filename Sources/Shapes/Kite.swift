//
//  Kite.swift
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

public struct Kite: Shape {
  public var pointRatio: CGFloat = 0.5
  
  public init(pointRatio: CGFloat) {
    self.pointRatio = pointRatio
  }
  
  public func path(in rect: CGRect) -> Path {
    return Path { path in
      path.move(to: CGPoint(x: rect.midX, y: 0))
      path.addLine(to: CGPoint(x: rect.maxX, y: rect.height * pointRatio))
      path.addLine(to: CGPoint(x: rect.midX, y: rect.height))
      path.addLine(to: CGPoint(x: rect.minX, y: rect.height * pointRatio))
      path.closeSubpath()
    }
  }
}

extension Kite: Animatable {
  public var animatableData: CGFloat {
    get {
      pointRatio
    }
    set {
      pointRatio = newValue
    }
  }
}

struct Kite_Previews: PreviewProvider {
    static var previews: some View {
      Kite(pointRatio: 0.2)
      .frame(width: 256, height: 256)
    }
}
