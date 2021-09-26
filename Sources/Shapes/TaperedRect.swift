//
//  TaperedRect.swift
//
//  Created by nutterfi on 2/16/21.
//

import SwiftUI

public struct TaperedRect: Polygon {
  public var inset: CGFloat = .zero
  public var sides: Int = 6
  public var taper: CGFloat = 0
  
  public init(taper: CGFloat) {
    self.taper = taper
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    
    let value = min(abs(taper), rect.midX)
    
    return [
      CGPoint(x: rect.minX, y: rect.midY),
      CGPoint(x: rect.minX + value, y: rect.minY),
      CGPoint(x: rect.maxX - value, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.midY),
      CGPoint(x: rect.maxX - value, y: rect.maxY),
      CGPoint(x: rect.minX + value, y: rect.maxY)
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

struct TaperedRect_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        TaperedRect(taper: 20)
          .frame(width:200, height:50)
        .foregroundColor(.green)
        
        TaperedRect(taper: 20)
          .inset(by: 20)
          .frame(width: 200, height: 50)
        .foregroundColor(.red)
      }
    }
}

