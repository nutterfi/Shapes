//
//  Polygon.swift
//
//  Created by nutterfi on 1/19/21.
//

import SwiftUI
// WIP
public struct Polygon: Shape {
  let sides: Int
  
  public init(sides: Int) {
    self.sides = abs(sides)
  }
  
  public static func coordinates(in rect: CGRect, sides: Int) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    var points = [CGPoint]()
    for index in 0 ..< sides {
      let theta: CGFloat = 2 * .pi * CGFloat(index) / CGFloat(sides)
      let x = origin.x + r * cos(theta)
      let y = origin.y + r * sin(theta)
      points.append(CGPoint(x: x, y: y))
    }
    return points
  }
  
  public func path(in rect: CGRect) -> Path {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    return Path { path in
      // initial point
      path.move(to: CGPoint(x: origin.x + r, y: origin.y))
      // determine the x and y coordinates for each side or vertex
      // then add the lines to the path
      let coordinates = Self.coordinates(in: rect, sides: sides)
      
      for coordinate in coordinates {
        path.addLine(to: coordinate)
      }
      path.closeSubpath()
    }
  }
}


let gradient = RadialGradient(gradient: Gradient(colors: [Color.pink, Color.purple]), center: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, startRadius: /*@START_MENU_TOKEN@*/5/*@END_MENU_TOKEN@*/, endRadius: 100)

struct Polygon_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
      Polygon(sides: 3)
        .fill(Color.red)
        .frame(width: 256, height: 256)
      }
      .previewLayout(.sizeThatFits)
    }
}
