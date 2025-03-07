import SwiftUI

/// An arrowhead shape with adjustable tip positions. Also known as a "dart".
public struct Arrowhead: Shape {
  
  /// The normalized tip position.
  public var tipPoint: CGPoint
  
  /// The normalized middle position
  public var midPoint: CGPoint
  
  /// Affects the curvature of the line on the right side
  public var controlPointRight: CGPoint
  
  /// Affects the curvature of the line on the left side
  public var controlPointLeft: CGPoint
  
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
    Path { path in
      path.move(to: CGPoint(x: rect.minX + tipPoint.x * rect.width, y: rect.minY + tipPoint.y * rect.height))
      
      path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.maxY),
                        control: CGPoint(x: rect.minX + controlPointRight.x * rect.width, y: rect.minY + controlPointRight.y * rect.height))
      
      path.addQuadCurve(to: CGPoint(x: rect.minX + midPoint.x * rect.width, y: rect.minY + midPoint.y * rect.height),
                        control: CGPoint(x: rect.maxX, y: rect.maxY))
      
      path.addQuadCurve(to: CGPoint(x: rect.minX, y: rect.maxY),
                        control: CGPoint(x: rect.minX, y: rect.maxY))
      
      path.addQuadCurve(to: CGPoint(x: rect.minX + tipPoint.x * rect.width, y: rect.minY + tipPoint.y * rect.height),
                        control: CGPoint(x: rect.minX + controlPointLeft.x * rect.width, y: rect.minY + controlPointLeft.y * rect.height))
      path.closeSubpath()
    }
  }
}

#Preview("Arrowhead") {
  VStack {
    
    let shape = Arrowhead(
      tipPoint: CGPoint(x: 0.5, y: 0),
      midPoint: CGPoint(x: 0.5, y: 0.75)
    )
    
    shape
    .stroke(Color.orange)
    .overlay {
      shape
      .inset(amount: 32)
    }
    
  }
  .border(Color.purple)
  .frame(width: 256, height: 256)
}
