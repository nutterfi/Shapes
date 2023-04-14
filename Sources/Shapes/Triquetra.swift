import SwiftUI

public struct Triquetra: NFiShape {
  public var inset: CGFloat = .zero
  
  /// whether to center the Triquetra in the frame
  /// the points on the triquetra will follow a circle inscribed in the path if not centered
  public var centered = false
  
  public var strokeStyle: StrokeStyle
  
  public init(strokeStyle: StrokeStyle = .init(), inset: CGFloat = .zero, centered: Bool = false) {
    self.strokeStyle = strokeStyle
    self.inset = inset
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
  
}

@available(*, deprecated, message: "Use Triquetra instead. TriquetraView will be removed in a later release")
public struct TriquetraView: View {
  public var strokeStyle: StrokeStyle
  
  public init(strokeStyle: StrokeStyle = .init()) {
    self.strokeStyle = strokeStyle
  }
  
  public var body: some View {
    Triquetra(strokeStyle: strokeStyle)
  }
}

struct Triquetra_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Circle().stroke()
        TriquetraView()
          .foregroundColor(Color.red.opacity(0.4))
        let lineWidth = 5.0
        
        Triquetra(strokeStyle: .init(lineWidth: lineWidth, lineCap: .round, lineJoin: .round, miterLimit: 0, dash: [10, 5, 2]))
          .inset(by: lineWidth / 2)
          
      }
      .frame(width: 128, height: 256)
    }
}
