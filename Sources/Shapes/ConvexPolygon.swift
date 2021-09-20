//
//  ConvexPolygon.swift
//
//  Created by nutterfi on 1/19/21.
//

import SwiftUI

public struct ConvexPolygon: RegularPolygon {
  public let sides: Int
  
  var inset: CGFloat = .zero
  
  public init(sides: Int) {
    self.sides = abs(sides)
  }
  
  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      let vertices = vertices(in: aRect)
      
      path.move(to: vertices.first!)
      
      vertices.forEach { vertex in
        path.addLine(to: vertex)
      }
      
      path.closeSubpath()
    }.rotation(.degrees(-90)).path(in: aRect)
  }
}

extension ConvexPolygon: InsettableShape {
  
  public func inset(by amount: CGFloat) -> some InsettableShape {
    var polygon = self
    polygon.inset += amount
    return polygon
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
          .strokeBorder(Color.green.opacity(0.5), lineWidth: 10)
        .border(Color.red)
      }
      .frame(width: 256, height: 256)
    }
}
