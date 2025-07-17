//
//  AnnularSteinerChain.swift
//  Shapes
//
//  Created by nutterfi on 7/16/25.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public struct AnnularSteinerChain: Shape {
  public var circleCount: Int
  public var renderRing: Bool
  
  public init(circleCount: Int = 6, renderRing: Bool = false) {
    self.circleCount = circleCount
    self.renderRing = renderRing
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let n = CGFloat(circleCount)
      let R = rect.breadth / 2
      
      let rectR = CGRect(center: rect.midXY, size: CGSize(width: rect.breadth, height: rect.breadth))

      
      if renderRing {
        path.addEllipse(in: rectR)
      }
      
      // now add small circles
      
      let theta = .pi / n // radians
      
      let expression = (1 + sin(theta)) / (1 - sin(theta))
      
      let r = R / expression
      
      // radius of circles inside ring
      let rho = (R - r) / 2
      
      let rRhoRect = CGRect(center: rect.midXY, size: CGSize(width: (r + rho) * 2, height: (r + rho) * 2))
      
      let vertices = ConvexPolygon(sides: circleCount).vertices(in: rRhoRect)
      
      for vertex in vertices {
        let rect = CGRect(center: vertex, size: CGSize(width: rho * 2, height: rho * 2))
        let p = Circle().path(in: rect)
        if renderRing {
          path = path.subtracting(p)
        } else {
          path.addPath(p)
        }
      }
      
      if renderRing {
        // inner ring
        let rRect = CGRect(center: rect.midXY, size: CGSize(width: r * 2, height: r * 2))
        path = path.subtracting(Circle().path(in: rRect))
      }
    }
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
  @Previewable @State var count: CGFloat = 6
  VStack {
    Slider(value: $count, in: 3...20, step: 1)
    HStack {
      AnnularSteinerChain(circleCount: Int(count))
      AnnularSteinerChain(circleCount: Int(count), renderRing: true)
    }
    .foregroundStyle(LinearGradient(colors: [.purple, .blue, .red], startPoint: .topLeading, endPoint: .bottomTrailing))
  }
}
