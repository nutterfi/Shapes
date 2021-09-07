//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

struct ReuleauxTriangle: Shape {
  func path(in rect: CGRect) -> Path {
    Path { path in
      let points = ConvexPolygon(sides: 3).vertices(in: rect)
      
      path.move(to: points[1])
      
      // polar coordinates
      let dx = abs(points[1].x - points[0].x)
      let dy = abs(points[1].y - points[0].y)
      let r = sqrt(dx * dx + dy * dy)
      
      // 0, 2, 1
      path.addRelativeArc(center: points[1], radius: r, startAngle: .degrees(-30), delta: .degrees(-60))
      
//      path.move(to: points[0])
      
      path.addRelativeArc(center: points[2], radius: r, startAngle: .degrees(-270), delta: .degrees(-60))
      
//      path.move(to: points[2])

      
      path.addRelativeArc(center: points[0], radius: r, startAngle: .degrees(-150), delta: .degrees(-60))
      
    }
    .rotation(.degrees(-90)).path(in: rect)
  }
  
}

struct ReuleauxTriangle_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      ReuleauxTriangle()
        .stroke() // FIXME: artifact shows up when closing path
        .foregroundColor(.purple)
    }
    .frame(width: 256, height: 256)
  }
}
