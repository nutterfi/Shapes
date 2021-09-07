//
//  ReuleauxPolygon.swift
//
//  Created by nutterfi on 9/7/21.
//

import SwiftUI
// WIP
// WARNING: DO NOT USE
struct ReuleauxPolygon: Shape {
  var sides: Int // MUST BE ODD

  /** N-sided Ex. Pentagon
      0 -> 2, 3    (i + 2, i+3) % N
      1 -> 3,4
      2 -> 4, 0
      3 -> 0, 1
      4 -> 1, 2
        
   N-sided polygon
   7-sided
      0 -> 3, 4   0 -> [(N-1)/2, (N-1)/2 + 1] % N
   jth index -> ((N-1)/2 + j, (N-1)/2 + 1 + j) % N
   9-sided
   0 -> 4,5
   */
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      let points = ConvexPolygon(sides: sides).vertices(in: rect)
      
      path.move(to: points[0])
      
      // polar coordinates
      let dx = abs(points[(sides-1)/2].x - points[0].x)
      let dy = abs(points[(sides-1)/2].y - points[0].y)
      let r = sqrt(dx * dx + dy * dy)
      
      // e.g. for a triangle, adding 120 degrees each time, is the opposite angle of the internal angle of the triangle (60deg)
      let internalAngleDegrees: CGFloat = 180.0 / CGFloat(sides)
      // 36 deg for a pentagon
      
      // start internalAngle + half the internal angle
      
      // while there are still vertices remaining, hop to the next vertex and repeat the process of adding an arc from the start angle to the end angle which is
      
      path.addRelativeArc(center: points.first!, radius: r, startAngle: .degrees(-180 + internalAngleDegrees*0.5), delta: .degrees(-internalAngleDegrees), transform: .init(rotationAngle: 0))
      
      path.addRelativeArc(center: points[0], radius: r, startAngle: .degrees(-180 + internalAngleDegrees*0.5), delta: .degrees(-internalAngleDegrees), transform:
                              .init(rotationAngle: Angle.degrees(internalAngleDegrees).radians))
      
//      path.addRelativeArc(center: points[2], radius: r, startAngle: .degrees(-270), delta: .degrees(-60))
      
      path.addRelativeArc(center: points[1], radius: r, startAngle: .degrees(-30), delta: .degrees(-60))
      
    }
    .rotation(.degrees(-90)).path(in: rect)
  }
  
  
    
}

struct ReuleauxPolygon_Previews: PreviewProvider {
    static var previews: some View {
      ReuleauxPolygon(sides: 3)
    }
}
