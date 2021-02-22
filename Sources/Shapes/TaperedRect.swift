//
//  TaperedRect.swift
//
//  Created by nutterfi on 2/16/21.
//

import SwiftUI

public struct TaperedRect: Shape {
  public var taper: CGFloat = 0
  
  public init(taper: CGFloat) {
    self.taper = taper
  }
  
  public func path(in rect: CGRect) -> Path {
    let height = rect.size.height
    let width = rect.size.width
    
    let value = min(taper, width / 2.0)
    
    return Path { path in
      path.move(to: CGPoint(x:0, y: height / 2))
      path.addLine(to: CGPoint(x: value, y: 0))
      path.addLine(to: CGPoint(x: width - value, y: 0))
      path.addLine(to: CGPoint(x: width, y: height / 2))
      path.addLine(to: CGPoint(x: width - value, y: height))
      path.addLine(to: CGPoint(x: value, y: height))
    }
  }
}

struct TaperedRect_Previews: PreviewProvider {
    static var previews: some View {
      TaperedRect(taper: 20)
        .frame(width:200, height:20)
        .foregroundColor(.green)
    }
}

