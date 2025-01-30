import SwiftUI

/// A bullet shape that faces to the right
public struct Bullet: Shape {
  
  /// Controls the sharpness of the bullet.
  public var taper: CGFloat = .zero
  
  /// The number of sides (inherited from Polygon).
  public var sides: Int = 5

  /// Creates a new bullet shape.
  public init(taper: CGFloat) {
    self.taper = abs(taper)
  }
  
  // MARK: Polygon
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let width = rect.size.width
    let value = min(taper, width / 2.0)

    return [
      CGPoint(x: rect.minX, y: rect.minY),
      CGPoint(x: rect.maxX - value, y: rect.minY),
      CGPoint(x: rect.maxX, y: rect.midY),
      CGPoint(x: rect.maxX - value, y: rect.maxY),
      CGPoint(x: rect.minX, y: rect.maxY)
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect))
      path.closeSubpath()
    }
  }
  
  // MARK: - Deprecations
  
  /// The inset amount applied to the bullet
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
}

struct Bullet_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Bullet(taper: 40)
          .fill(Color.blue)
        
        Bullet(taper: 80)
          .inset(amount: 10)
          .fill(Color.red)
      }
      .frame(width: 80, height: 40)
    }
}
