import SwiftUI

/// A heart shape.
public struct Heart: Shape {
  
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

  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: rect.projectedPoint(origin))
      path.addCurve(to: rect.projectedPoint(bottom), control1: rect.projectedPoint(controlLeft1), control2: rect.projectedPoint(controlLeft2))
      path.addCurve(to: rect.projectedPoint(origin), control1: rect.projectedPoint(controlRight2), control2: rect.projectedPoint(controlRight1))
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
