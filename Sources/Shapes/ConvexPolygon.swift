//
//  ConvexPolygon.swift
//
//  Created by nutterfi on 1/19/21.
//

import SwiftUI

public struct ConvexPolygon: RegularPolygon {
  public var sides: Int
  
  public var inset: CGFloat = .zero
  
  public init(sides: Int) {
    self.sides = abs(sides)
  }
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.addLines(vertices(in: aRect))
      path.closeSubpath()
    }
  }
}

extension ConvexPolygon: Animatable {
  public var animatableData: CGFloat {
    get {
      CGFloat(sides)
    }
    set {
      sides = Int(newValue)
    }
  }
}

struct ConvexPolygon_Previews: PreviewProvider {
    static var previews: some View {
      let inset: CGFloat = 50
      ZStack {
        Circle()
          .inset(by: inset)
          .strokeBorder(Color.red, lineWidth: 10)
        
        ConvexPolygon(sides: 7)
          .inset(by: inset)
          .strokeBorder(Color.green.opacity(0.8), lineWidth: 10)
        .border(Color.red)
        
        let vertices = ConvexPolygon(sides: 7)
          .vertices(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        ForEach(0..<vertices.count, id: \.self) { index in
          let vertex = vertices[index]
          Circle().frame(width:10).offset(x: -128 + vertex.x, y: -128 + vertex.y)
        }
        
      }
      .frame(width: 256, height: 256)
    }
}
