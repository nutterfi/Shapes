//
//  StarPolygon.swift
//
//  Created by nutterfi on 8/31/21.
//

import SwiftUI

/**
  A non-convex regular polygon. Draws the shape by connecting with straight lines every qth point out of p regularly spaced points lying on a circle
 
  Use the stroke() modifier to see the invidual lines
  Ref: https://mathworld.wolfram.com/StarPolygon.html
 */
public struct StarPolygon: RegularPolygon {
  
  public var inset: CGFloat = 0
  public var sides: Int
  
  /// The density of a star polygon. All possible permutations can be generated with density values less than half of the number of points (q < p/2)
  var density: Int
  
  public init(points: Int, density: Int) {
    self.sides = abs(points)
    self.density = abs(density)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let vertices = vertices(in: rect.insetBy(dx: inset, dy: inset))
      path.move(to: vertices.first!)
      
      var usedIndexes = Set<Int>()
      let allIndexes = Set(0..<sides)
      
      var pIndex = 0
      
      // if all points are not connected after the first pass, i.e., if (p,q)!=1, then start with the first unconnected point and repeat the procedure
      while usedIndexes != allIndexes {
        if usedIndexes.contains(pIndex) {
          pIndex = (pIndex + 1) % sides
          path.move(to: vertices[pIndex])
        } else {
          usedIndexes.insert(pIndex)
        
          pIndex = (pIndex + density) % sides
          path.addLine(to: vertices[pIndex])
        }
      }
      
      path.closeSubpath()
    }
  }
  
}

extension StarPolygon: Animatable {
  public var animatableData: AnimatablePair<CGFloat, CGFloat> {
    get {
      AnimatablePair(CGFloat(sides), CGFloat(density))
    }
    set {
      sides = Int(newValue.first)
      density = Int(newValue.second)
    }
  }
}

public struct StarPolygon_Previews: PreviewProvider {
  public static var previews: some View {
    ZStack {
      StarPolygon(points: 5, density: 2)
        
      StarPolygon(points: 5, density: 2)
        .inset(by: 50)
        .stroke(Color.green)
        
    }
  }
}
