import SwiftUI

/// Generates a repeated pattern of the provided shape on a circular path
public struct CirclePattern<Content: Shape>: Shape {
  public var pattern: Content
  public var repetitions: Int
  
  public init(pattern: Content, repetitions: Int = 10) {
    self.pattern = pattern
    self.repetitions = repetitions
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let dim = min(rect.width, rect.height)
      let scaledDim = dim / CGFloat(repetitions)
      let insetRect = rect.insetBy(dx: scaledDim * 0.5, dy: scaledDim * 0.5)
      let vertices = ConvexPolygon(
        sides: repetitions)
        .vertices(in: insetRect)
      
      for n in 0..<repetitions {
        let vertex = vertices[n]
        let angle = atan2((vertex.y - rect.midY), (vertex.x - rect.midX))
        let scaledRect = CGRect(
          origin: .init(x: -scaledDim * 0.5 + vertex.x, y: -0.5 * scaledDim + vertex.y),
          size: .init(width: scaledDim, height: scaledDim)
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
    ZStack {
      Color.black.ignoresSafeArea()
      Circle()
      
      CirclePattern(pattern: Rectangle(), repetitions: 20)
        .border(Color.red)
        .foregroundColor(.orange)
    }
    .frame(width: 200, height: 300)
  }
}
