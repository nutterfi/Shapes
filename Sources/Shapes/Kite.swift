//
//  Kite.swift
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

public struct Kite: Polygon {
  public var inset: CGFloat = .zero
  
  public var sides: Int = 4
  
  public var pointRatio: CGFloat = 0.5
  
  public init(pointRatio: CGFloat) {
    self.pointRatio = pointRatio
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    [
      CGPoint(x: rect.midX, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.minY + rect.height * pointRatio),
      CGPoint(x: rect.midX, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.minY + rect.height * pointRatio)
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.addLines(vertices(in: aRect))
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
      GeometryReader { proxy in
        let dim = min(proxy.size.width, proxy.size.height)
        ZStack {
          ForEach(0...100, id: \.self) { index in
            Kite(pointRatio: 0.5)
            .inset(by: CGFloat(index) / 100 * dim)
            .stroke()
            .border(Color.black)
          }
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
      .frame(width: 256, height: 256)
      
    }
}
