//
//  ConvexPolygon.swift
//
//  Created by nutterfi on 1/19/21.
//

import SwiftUI

public struct ConvexPolygon: RegularPolygon {
  public let sides: Int
  
  public init(sides: Int) {
    self.sides = abs(sides)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let vertices = vertices(in: rect)
      
      path.move(to: vertices.first!)
      
      vertices.forEach { vertex in
        path.addLine(to: vertex)
      }
      
      path.closeSubpath()
    }
  }
}

struct ConvexPolygon_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
      ConvexPolygon(sides: 8)
        .fill(Color.red)
      }
    }
}
