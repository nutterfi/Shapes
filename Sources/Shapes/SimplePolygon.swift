//
//  SimplePolygon.swift
//
//  Created by nutterfi on 9/9/21.
//

import SwiftUI

public struct SimplePolygon: Polygon {
  
  public var inset: CGFloat = .zero
  public var sides: Int {
    ratios.count
  }
  
  var ratios: [CGFloat] = []
  
  init(sides: Int) {
    for _ in 0..<sides {
      ratios.append(CGFloat.random(in: 0...1))
      ratios = ratios.sorted()
    }
  }
  
  init(ratios: [CGFloat]) {
    self.ratios = ratios.sorted()
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    return ratios.map {
      let theta = 2 * .pi * $0
      return CGPoint(x: origin.x + r * cos(theta), y: origin.y + r * sin(theta))
    }
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let vertices = vertices(in: rect)
      
      path.move(to: vertices.first ?? .zero)
      
      vertices.forEach { vertex in
        path.addLine(to: vertex)
      }
    }
  }
  
}

struct SimplePolygon_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Circle().stroke()
        SimplePolygon(ratios: [0.1, 0.5, 0.756, 0.3, 0.4])
        .foregroundColor(Color.blue)
        .opacity(0.3)
      }
      .frame(width: 256, height: 256)
      .previewDevice("iPhone 12 Pro Max")
    }
}
