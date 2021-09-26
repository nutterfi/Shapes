//
//  Bullet.swift
//  
//
//  Created by nutterfi on 2/23/21.
//

import SwiftUI

public struct Bullet: Polygon {
  
  public var inset: CGFloat = .zero
  public var taper: CGFloat = .zero
  public var sides: Int = 5

  public init(taper: CGFloat) {
    self.taper = abs(taper)
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let width = rect.size.width
    let value = min(taper, width / 2.0)
    
    return [
      CGPoint(x: rect.minX, y: rect.minY),
      CGPoint(x: rect.minX + value, y: rect.minY),
      CGPoint(x: rect.maxX - value, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.midY),
      CGPoint(x: rect.maxX - value, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.maxY)
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect.insetBy(dx: inset, dy: inset)))
      path.closeSubpath()
    }
  }
}

struct Bullet_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Bullet(taper: 40)
          .fill(Color.blue)
        
        Bullet(taper: 80)
          .inset(by: 10)
          .fill(Color.red)
      }
      .frame(width: 80, height: 40)
    }
}
