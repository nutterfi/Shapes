import SwiftUI

public struct RoundedPolygon: Shape {
  public let sides: Int
  public var cornerRadius: CGFloat = 0
  
  public init(sides: Int, cornerRadius: CGFloat) {
    self.sides = sides
    self.cornerRadius = cornerRadius
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      var points = [CGPoint]()
      let radius = min(rect.width, rect.height) / 2
      let origin = CGPoint(x: rect.midX, y: rect.midY)
      let pSides = sides == 0 ? 2 : abs(sides)
      let pCornerRadius = abs(cornerRadius)
      
      for n in 0..<pSides {
        let theta = 2 * .pi * CGFloat(n) / CGFloat(pSides)
        let x = radius * cos(theta)
        let y = radius * sin(theta)
        points.append(.init(x: x + origin.x, y: y + origin.y))

      }
      
      if pCornerRadius == 0 {
        path.addLines(points)
      } else {
        
        let interiorAngleSumDegrees = 180.0 * CGFloat(pSides - 2)
        let interiorAngle = interiorAngleSumDegrees / CGFloat(pSides)
        let interiorAngleHalf = interiorAngle / 2
        let innerRadius = radius * sin(interiorAngleHalf * .pi / 180)
        
        let maxRadius = min(pCornerRadius, innerRadius)
        let midPointX = 0.5 * (points[0].x + points[1].x)
        let midPointY = 0.5 * (points[0].y + points[1].y)
        let midPoint = CGPoint(x: midPointX, y: midPointY)
        
        path.move(to: midPoint)
        for n in 1...pSides {
          path.addArc(
            tangent1End: points[n % pSides],
            tangent2End: points[(n+1) % pSides],
            radius: maxRadius
          )
        }

      }
      path.closeSubpath()
    }
  }
}


struct SwiftUIView_Previews: PreviewProvider {
    static var previews: some View {
        RoundedPolygon(sides: 5, cornerRadius: 40)
    }
}
