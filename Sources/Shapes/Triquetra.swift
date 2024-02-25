import SwiftUI

/// A triquetra shape.
public struct Triquetra: NFiShape {
  /// The inset of the shape.
  public var inset: CGFloat = .zero
  
  /// Whether to center the Triquetra in the frame.
  /// The points on the triquetra will follow a circle inscribed in the path if not centered
  public var centered = false
  
  /// The style applied to the shape.  Uses the default initializer if not specified.
  public var strokeStyle: StrokeStyle
  
  /// Constructs a new triquetra shape.
  /// - Parameters:
  ///   - strokeStyle: The style applied to the shape.  Uses the default initializer if not specified.
  ///   - centered: Whether to center the Triquetra in the frame.
  public init(strokeStyle: StrokeStyle = StrokeStyle(), centered: Bool = false) {
    self.strokeStyle = strokeStyle
    inset = .zero
    self.centered = centered
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      let vertices = ConvexPolygon(sides: 3).vertices(in: insetRect)
      
      let dim = min(insetRect.width, insetRect.height)
      
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
      
      if centered {
        let bounding = path.boundingRect
        let boundingDim = max(bounding.width, bounding.height)
        
        path = path
          .offsetBy(dx: insetRect.midX - bounding.midX, dy: insetRect.midY - bounding.midY)
          .scale(dim / boundingDim)
          .path(in: insetRect)
      }
      
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
        
        VStack {
          Text("Not Centered")
          Triquetra(strokeStyle: style)
            .inset(by: lineWidth / 2)
            .background {
              Circle()
                .stroke(Color.blue.opacity(0.4))
            }
          .border(Color.red)
        }
        
        VStack {
          Text("Centered")
          Triquetra(strokeStyle: style, centered: true)
            .inset(by: lineWidth / 2)
            .background {
              Circle()
                .stroke(Color.blue.opacity(0.4))
            }
          .border(Color.red)
        }
        
      }
      .padding()
    }
}
