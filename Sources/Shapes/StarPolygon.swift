//
//  StarPolygon.swift
//
//  Created by nutterfi on 8/31/21.
//

import SwiftUI

// https://mathworld.wolfram.com/StarPolygon.html
public struct StarPolygon: Shape {
  
  let p: Int
  let q: Int
  
  // p, q > 0
  // q < p/2
  
  public init(points: Int, density: Int) {
    self.p = abs(points)
    self.q = abs(density)
  }
  
  public func path(in rect: CGRect) -> Path {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    return Path { path in
      
      // connecting with straight lines every qth point out of p regularly spaced points lying on a circumference
      
      //  if all points are not connected after the first pass, i.e., if (p,q)!=1, then start with the first unconnected point and repeat the procedure
      
      
      // initial point
      path.move(to: CGPoint(x: origin.x + r, y: origin.y))

      let coordinates = Self.coordinates(in: rect, p: p)
      
      var completed = Set<Int>()
      let allIndexes = Array(0..<p)
      
      var pIndex = 0
      
      // make sure we use all the points
      while completed != Set(allIndexes) {
        if completed.contains(pIndex) {
          pIndex = (pIndex + 1) % p
          path.move(to: coordinates[pIndex])
        } else {
          completed.insert(pIndex)
        
          pIndex = (pIndex + q) % p
          path.addLine(to: coordinates[pIndex])
        }
      }
      
      path.closeSubpath()
    }
  }
  
  // obtains p equally spaced points around a circle inscribed in rect
  public static func coordinates(in rect: CGRect, p: Int) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    var points = [CGPoint]()
    for index in 0 ..< p {
      let theta: CGFloat = 2 * .pi * CGFloat(index) / CGFloat(p)
      let x = origin.x + r * cos(theta)
      let y = origin.y + r * sin(theta)
      points.append(CGPoint(x: x, y: y))
    }
    return points
  }
  
}

public struct StarPolygon_Previews: PreviewProvider {
  public static var previews: some View {
    StarPolygon(points: 5, density: 2)
      .stroke()
      .rotation(.degrees(-90))
  }
}
