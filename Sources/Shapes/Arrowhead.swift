import SwiftUI

/// An arrowhead shape with adjustable tip positions. Also known as a "dart".
public struct Arrowhead: NFiShape {
  
  /// The normalized tip position.
  public var tipPoint: CGPoint
  
  /// The normalized middle position
  public var midPoint: CGPoint
  
  /// Affects the curvature of the line on the right side
  public var controlPointRight: CGPoint
  
  /// Affects the curvature of the line on the left side
  public var controlPointLeft: CGPoint
  
  /// The inset value of the arrowhead
  public var inset: CGFloat = .zero
  
  /// Creates a new arrowhead shape.
  public init(
    tipPoint: CGPoint = CGPoint(x: 0.5, y: 0),
    midPoint: CGPoint = CGPoint(x: 0.5, y: 0.75),
    controlPointRight: CGPoint = CGPoint(x: 0.75, y: 0.5),
    controlPointLeft: CGPoint = CGPoint(x: 0.25, y: 0.5)
  ) {
    self.tipPoint = tipPoint
    self.midPoint = midPoint
    self.controlPointLeft = controlPointLeft
    self.controlPointRight = controlPointRight
  }

  public func path(in rect: CGRect) -> Path {
    let aRect = rect.insetBy(dx: inset, dy: inset)

    return Path { path in
      path.move(to: CGPoint(x: aRect.minX + tipPoint.x * aRect.width, y: aRect.minY + tipPoint.y * aRect.height))
      
      path.addQuadCurve(to: CGPoint(x: aRect.maxX, y: aRect.maxY),
                        control: CGPoint(x: aRect.minX + controlPointRight.x * aRect.width, y: aRect.minY + controlPointRight.y * aRect.height))
      
      path.addQuadCurve(to: CGPoint(x: aRect.minX + midPoint.x * aRect.width, y: aRect.minY + midPoint.y * aRect.height),
                        control: CGPoint(x: aRect.maxX, y: aRect.maxY))
      
      path.addQuadCurve(to: CGPoint(x: aRect.minX, y: aRect.maxY),
                        control: CGPoint(x: aRect.minX, y: aRect.maxY))
      
      path.addQuadCurve(to: CGPoint(x: aRect.minX + tipPoint.x * aRect.width, y: aRect.minY + tipPoint.y * aRect.height),
                        control: CGPoint(x: aRect.minX + controlPointLeft.x * aRect.width, y: aRect.minY + controlPointLeft.y * aRect.height))
      path.closeSubpath()
    }
  }
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Arrowhead(tipPoint: CGPoint(x: 0.5, y: 0),
              midPoint: CGPoint(x: 0.5, y: 0.75))
            .fill(Color.orange)
        
        Arrowhead(tipPoint: CGPoint(x: 0.5, y: 0),
              midPoint: CGPoint(x: 0.5, y: 0.75))
          .inset(by: 32)
      }
      .border(Color.purple)
      .frame(width: 256, height: 256)
    }
}
