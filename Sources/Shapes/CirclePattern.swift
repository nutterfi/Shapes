import SwiftUI

/// Generates a repeated pattern of the provided shape on a circular path
public struct CirclePattern<Content: Shape>: Shape {
  /// The shape used to buid the pattern
  public var pattern: Content
  
  /// The number of shapes used to build the pattern
  public var repetitions: Int
  
  /// The spacing between each component in the pattern
  public var spacing: Double = 0
  
  /// Generates a new circle pattern.
  public init(pattern: Content, repetitions: Int = 10) {
    self.pattern = pattern
    self.repetitions = max(2, repetitions)
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let inset = rect.breadth / CGFloat(repetitions) * 0.8
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      let vertices = ConvexPolygon(sides: repetitions)
        .vertices(in: insetRect)
      
      for n in 0..<repetitions {
        let vertex = vertices[n]
        let angle = atan2((vertex.y - rect.midY), (vertex.x - rect.midX))
        let scaledRect = CGRect(
          origin: CGPoint(x: -inset + vertex.x, y: -inset + vertex.y),
          size: CGSize(width: inset * 2, height: inset * 2)
        )
        
        let iPath = pattern.path(in: scaledRect)
          .rotation(.radians(angle + CGFloat.pi / 2))
          .path(in: scaledRect)
        
        path.addPath(iPath)
      }
    }
  }
}

struct CirclePattern_Previews: PreviewProvider {
  static var previews: some View {
    ZStack(alignment: .topLeading) {
      Color.black.ignoresSafeArea()
      Circle()
        .foregroundStyle(Color.white)
        .border(Color.blue)
      
      CirclePattern(pattern: Salinon(), repetitions: 9)
        .border(Color.red)
        .foregroundStyle(.orange)
    }
  }
}
