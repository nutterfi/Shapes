import SwiftUI

/// A convex regular polygon
public struct ConvexPolygon: RegularPolygon {
  /// The number of polygon sides
  public var sides: Int
  
  /// The inset amount of the polygon
  public var inset: CGFloat = .zero
  
  /// Creates a new convex polygon
  public init(sides: Int) {
    self.sides = abs(sides)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.addLines(vertices(in: rect.insetBy(dx: inset, dy: inset)))
      path.closeSubpath()
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
}

extension ConvexPolygon: Animatable {
  public var animatableData: CGFloat {
    get {
      CGFloat(sides)
    }
    set {
      sides = Int(newValue)
    }
  }
}

struct ConvexPolygon_Previews: PreviewProvider {
    static var previews: some View {
      let inset: CGFloat = 50
      ZStack {
        Circle()
          .inset(by: inset)
          .strokeBorder(Color.red, lineWidth: 10)
        
        ConvexPolygon(sides: 7)
          .inset(by: inset)
          .strokeBorder(Color.green.opacity(0.8), lineWidth: 10)
        .border(Color.red)
        
        let vertices = ConvexPolygon(sides: 7)
          .vertices(in: CGRect(x: 0, y: 0, width: 256, height: 256))
        
        ForEach(0..<vertices.count, id: \.self) { index in
          let vertex = vertices[index]
          Circle()
            .frame(width:10)
            .offset(x: -128 + vertex.x, y: -128 + vertex.y)
        }
        
      }
      .frame(width: 256, height: 256)
    }
}
