//
//  Bullet.swift
//  
//
//  Created by nutterfi on 2/23/21.
//

import SwiftUI

public struct Bullet: Shape {
  public var taper: CGFloat = 0

  public init(taper: CGFloat) {
    self.taper = abs(taper)
  }
  
  public func path(in rect: CGRect) -> Path {
    let height = rect.size.height
    let width = rect.size.width
    
    let value = min(taper, width / 2.0)
    
    return Path { path in
      path.move(to: CGPoint(x:0, y: 0))
      path.addLine(to: CGPoint(x: value, y: 0))
      path.addLine(to: CGPoint(x: width - value, y: 0))
      path.addLine(to: CGPoint(x: width, y: height / 2))
      path.addLine(to: CGPoint(x: width - value, y: height))
      path.addLine(to: CGPoint(x: 0, y: height))
      path.closeSubpath()
    }
  }
}

struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
      Bullet(taper: -40)
        .fill(Color.blue)
        .frame(width: 80, height: 40)
    }
}
