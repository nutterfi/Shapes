//
//  Egg.swift
//  
//
//  Created by nutterfi on 10/19/21.
//

import SwiftUI

/// Draws a Moss's egg shape
/// https://en.wikipedia.org/wiki/Moss%27s_egg
public struct Egg: Shape {
  
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
    
      let mid = CGPoint(x: rect.midX, y: rect.midY)
      
      let ac = min(rect.width, rect.height)
      let c = CGPoint(x: rect.midX + ac * 0.5, y: rect.midY)
      let a = CGPoint(x: rect.midX - ac * 0.5, y: rect.midY)
      
      path.move(to: c)
      path.addArc(center: mid, radius: ac * 0.5, startAngle: .zero, endAngle: .init(degrees: 180), clockwise: false)
      
      // Draw from A to D; center is C
      path.addArc(center: c, radius: ac, startAngle: .init(degrees: 180), endAngle: .init(degrees: 180 + angleC), clockwise: false)
      
      // SOH: sin(theta) = O/H; H = O/sin(theta)
      let bc = ac * 0.5 / sin(apexAngle/2 * .pi / 180)
      let bq = sqrt(bc * bc - ac * ac / 4)
      let b = CGPoint(x: rect.midX, y: rect.midY - bq)
      
      let bd = ac - bc
      
      // Draw from D to E; center is B
      path.addArc(center: b, radius: bd, startAngle: .init(degrees: 180 + angleC), endAngle: .init(degrees: 180 + angleC + apexAngle), clockwise: false)
            
      // Draw from E to C; center is A
      path.addArc(center: a, radius: ac, startAngle: .init(degrees: 180 + angleC + apexAngle), endAngle: .zero, clockwise: false)
      
      path.closeSubpath()
      
      let bounding = path.boundingRect
      
      path = path
        .offsetBy(dx: rect.midX - bounding.midX, dy: rect.midY - bounding.midY)
      
      let boundMin = min(bounding.width, bounding.height)
      let boundMax = max(bounding.width, bounding.height)
      
      let insetMin = min(rect.width, rect.height)
      let insetMax = max(rect.width, rect.height)
      
      path = path.scale(x: insetMin / boundMax, y: insetMin / boundMax).path(in: rect)

    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  // MARK: - Deprecations
  
  /// The inset amount of the shape
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
  
}

struct Egg_Previews: PreviewProvider {
    static var previews: some View {
      Group {
        Egg(apexAngle: 78)
          .inset(amount: 30)
          .stroke()
          .rotationEffect(.radians(.pi))
          .frame(width: 512, height: 128)
        
        Egg(apexAngle: 78)
          .inset(amount: 30)
          .stroke()
          .frame(width: 256, height: 256)
        
        Egg(apexAngle: 78)
          .inset(amount: 30)
          .frame(width: 128, height: 150)
      }
      .border(Color.primary)
      .padding()
      .previewLayout(.sizeThatFits)
    }
}
