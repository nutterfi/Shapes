import SwiftUI

/// A heart shape.
public struct Heart: NFiShape {
  
  /// the top center of the heart
  private let origin = UnitPoint(x: 0.5, y: 0.2)
  
  /// the bottom center of the heart
  private let bottom = UnitPoint(x: 0.5, y: 1)
  
  /// The first control point that draws the left side curve
  private let controlLeft1 = UnitPoint(x: 0.2, y: -0.35)
  
  /// The second control point that draws the left side curve
  private let controlLeft2 = UnitPoint(x: -0.4, y: 0.45)
  
  /// The first control point that draws the right side curve
  private let controlRight1 = UnitPoint(x: 0.8, y: -0.35)
  
  /// The second control point that draws the right side curve
  private let controlRight2 = UnitPoint(x: 1.4, y: 0.45)
  
  /// The inset of the shape
  public var inset: CGFloat = .zero

  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      path.move(to: insetRect.projectedPoint(origin))
      path.addCurve(to: insetRect.projectedPoint(bottom), control1: insetRect.projectedPoint(controlLeft1), control2: insetRect.projectedPoint(controlLeft2))
      path.addCurve(to: insetRect.projectedPoint(origin), control1: insetRect.projectedPoint(controlRight2), control2: insetRect.projectedPoint(controlRight1))
      path.closeSubpath()
    }
  }
    
}

struct Heart_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        Heart()
          .strokeBordered(50)
          .scaledToFit()
          .border(Color.red)
        
          Color.clear.background {
            Image(systemName: "heart")
              .resizable()
              .scaledToFit()
              .border(Color.red)
          }
      }
      
    }
}
