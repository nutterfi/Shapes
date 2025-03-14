import SwiftUI

/// A triquetra shape.
public struct Triquetra: Shape {
  
  /// The style applied to the shape.  Uses the default initializer if not specified.
  public var strokeStyle: StrokeStyle
  
  /// Constructs a new triquetra shape.
  /// - Parameters:
  ///   - strokeStyle: The style applied to the shape.  Uses the default initializer if not specified.
  ///   - centered: Whether to center the Triquetra in the frame.
  public init(strokeStyle: StrokeStyle = StrokeStyle()) {
    self.strokeStyle = strokeStyle
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let vertices = ConvexPolygon(sides: 3).vertices(in: rect)

      let x = (vertices[1].x - vertices[0].x)
      let y = (vertices[1].y - vertices[0].y)
      let length = sqrt(x * x + y * y) * 0.5
      
      let mp1 = (vertices[0] + vertices[1]) * 0.5
      let mp2 = (vertices[1] + vertices[2]) * 0.5
      let mp3 = (vertices[2] + vertices[0]) * 0.5
      
      path.addArc(center: mp1, radius: length, startAngle: .degrees(60), endAngle: .degrees(240), clockwise: false)
      
      path.addArc(center: mp3, radius: length, startAngle: .degrees(300), endAngle: .degrees(120), clockwise: false)
      
      path.addArc(center: mp2, radius: length, startAngle: .degrees(180), endAngle: .degrees(360), clockwise: false)
      
      path.closeSubpath()
      
      path = path.strokedPath(strokeStyle)
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
}

struct Triquetra_Previews: PreviewProvider {
    static var previews: some View {
      HStack {
        let lineWidth = 5.0
        let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [10, 5, 2])

        Triquetra(strokeStyle: style)
          .inset(amount: lineWidth / 2)
          .background {
            Circle()
              .stroke(Color.blue.opacity(0.4))
          }
          .border(Color.red)
      }
      .padding()
    }
}
