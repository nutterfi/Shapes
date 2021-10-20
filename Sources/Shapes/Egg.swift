//
//  Egg.swift
//  
//
//  Created by nutterfi on 10/19/21.
//

import SwiftUI

/// Draws a Moss's egg shape
/// https://en.wikipedia.org/wiki/Moss%27s_egg
public struct Egg: NFiShape {
  public var inset: CGFloat = .zero
  
  public var apexAngle: CGFloat
  
  public init(apexAngle: CGFloat = 90) {
    self.apexAngle = min(179, max(61, abs(apexAngle)))
  }
  
  var angleC: CGFloat {
    (180 - apexAngle) * 0.5
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      /**
       1. Draw a semicircle on the base AC of the triangle, outside of the triangle.
       2. Connect it to a circular arc centered at C from A to a point D on line BC, and by another circular arc centered at A from C to a point E on line AB. When the apex angle at B is greater than 60°, these two points D and E will be outside the triangle, equidistant from B.
       3. Complete the oval by a circular arc centered at B, from D to E.
       */
      let insetRect = rect.insetBy(dx: inset, dy: inset)
    
      let mid = CGPoint(x: insetRect.midX, y: insetRect.midY)
      
      let ac = min(insetRect.width, insetRect.height)
      let c = CGPoint(x: insetRect.midX + ac * 0.5, y: insetRect.midY)
      let a = CGPoint(x: insetRect.midX - ac * 0.5, y: insetRect.midY)
      
      path.move(to: c)
      path.addArc(center: mid, radius: ac * 0.5, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: false)
      
      // Draw from A to D; center is C
      path.addArc(center: c, radius: ac, startAngle: .init(degrees: 180), endAngle: .init(degrees: 180 + angleC), clockwise: false)
      
      // SOH: sin(theta) = O/H; H = O/sin(theta)
      let bc = ac * 0.5 / sin(apexAngle/2 * .pi / 180)
      let bq = sqrt(bc * bc - ac * ac / 4)
      let b = CGPoint(x: insetRect.midX, y: insetRect.midY - bq)
      
      let bd = ac - bc
      
      // Draw from D to E; center is B
      path.addArc(center: b, radius: bd, startAngle: .init(degrees: 180 + angleC), endAngle: .init(degrees: 180 + angleC + apexAngle), clockwise: false)
            
      // Draw from E to C; center is A
      path.addArc(center: a, radius: ac, startAngle: .init(degrees: 180 + angleC + apexAngle), endAngle: .zero, clockwise: false)
      
      path.closeSubpath()
      
      let bounding = path.boundingRect
      
      path = path
        .offsetBy(dx: insetRect.midX - bounding.midX, dy: insetRect.midY - bounding.midY)
      
      let boundMin = min(bounding.width, bounding.height)
      let boundMax = max(bounding.width, bounding.height)
      
      let insetMin = min(insetRect.width, insetRect.height)
      let insetMax = max(insetRect.width, insetRect.height)
      
      path = path.scale(x: insetMin / boundMax, y: insetMin / boundMax).path(in: insetRect)

    }
  }
}

struct Egg_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Egg(apexAngle: 78)
          .inset(by: 30)
          .stroke()
          .rotationEffect(.radians(.pi))
          .frame(width: 512, height: 128)
        
        Egg(apexAngle: 78)
          .inset(by: 30)
          .stroke()
          .frame(width: 256, height: 256)
        
        Egg(apexAngle: 78)
          .inset(by: 30)
          .frame(width: 128, height: 150)
      }
      .previewLayout(.sizeThatFits)
      .border(Color.black)
    }
}
