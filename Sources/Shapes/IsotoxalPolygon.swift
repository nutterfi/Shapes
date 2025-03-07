import SwiftUI

/// An even-sided equilateral polygon. An isotoxal polygon has symmetry on its edges.
///
/// In this implementation, the polygon is constructed with an array of points which are positioned relative to a circle that fits the bounds of the shape. The `innerRadius` is used to compute the position of the even-indexed points. Values less than one position those points toward the shape's center.
public struct IsotoxalPolygon: Shape, Polygon {
  /// Number of sides. All isotoxal polygons must have even number of sides
  public var sides: Int
  
  /// The relative radius of the even-indexed points. Valid for values between 0 and 1.
  public var innerRadius: CGFloat
  
  /// Constructs a new polygon
  /// - Parameters:
  ///   - sidePairs: Number of pairs of sides of the polygon
  ///   - innerRadius: Relative position of the inner points of the polygon, between 0...1
  public init(sidePairs: Int, innerRadius: CGFloat = 1.0) {
    self.sides = abs(2 * sidePairs)
    self.innerRadius = max(0, min(1, innerRadius))
  }
  
  /// The positions of the polygon corners, ordered by their angular position around the circle. Every even-numbered point is positioned based on the `innerRadius`
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let r = rect.breadth / 2
    let origin = rect.midXY
    return (0 ..< sides).map {
      let radius = $0 % 2 == 0 ? r : r * innerRadius
      let theta = 2 * .pi * CGFloat($0) / CGFloat(sides) - .pi / 2 // the origin will now be facing north
      return CGPoint(x: origin.x + radius * cos(theta), y: origin.y + radius * sin(theta))
    }
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect))
      path.closeSubpath()
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
}

extension IsotoxalPolygon: Animatable {
  public var animatableData: CGFloat {
    get {
      innerRadius
    }
    set {
      innerRadius = newValue
    }
  }
}

struct IsotoxalPolygon_Previews: PreviewProvider {
  
  struct IsotoxalPolygonDemo: View {
    @State private var sides: Float = 10
    @State private var innerRadius: CGFloat = 0.5
    
    var body: some View {
      VStack {
        Text("Side Pairs: \(Int(sides))")
        Slider(value: $sides, in: 2...40)
        
        Text("InnerRadius: \(String(format: "%.2f", innerRadius))")
        Slider(value: $innerRadius)
        
        IsotoxalPolygon(sidePairs: Int(sides), innerRadius: innerRadius)
          .stroke()
          .background {
            Circle().stroke(Color.gray, lineWidth: 0.5)
          }

        Spacer()
      }
      .padding()
    }
  }
  
  static var previews: some View {
    IsotoxalPolygonDemo()
  }
}
