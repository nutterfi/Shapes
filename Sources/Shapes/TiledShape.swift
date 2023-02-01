import SwiftUI

public struct TiledShape<Content: Shape>: Shape {
  public var shape: Content
  public var rows: Int
  public var columns: Int
  
  public init(shape: Content, rows: Int = 1, columns: Int = 1) {
    self.shape = shape
    self.rows = rows
    self.columns = columns
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let width = rect.width / CGFloat(columns)
      let height = rect.height / CGFloat(rows)
      for r in 0..<rows {
        for c in 0..<columns {
          let origin = CGPoint(
            x: rect.minX + CGFloat(c) * width,
            y: rect.minY + CGFloat(r) * height
          )
          let iRect = CGRect(origin: origin, size: CGSize(width: width, height: height))
          
          path.addPath(shape.path(in: iRect))
        }
      }
    }
  }
}

extension Shape {
  func tiled(rows: Int, columns: Int) -> TiledShape<Self> {
    TiledShape(shape: self, rows: rows, columns: columns)
  }
}

struct TiledShape_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        Color.orange.ignoresSafeArea()
        if #available(iOS 16.0, *) {
          TiledShape(shape: Reuleaux.triangle, rows: 8, columns: 8)
            .stroke(lineWidth: 5)
            .foregroundStyle(.white)
            .frame(width: 256, height: 256)
          
          Circle().adding(StarPolygon(points: 5, density: 2)).tiled(rows: 2, columns: 2)
            
            .opacity(0.5)
            .frame(width: 256, height: 256)
        } else {
          // Fallback on earlier versions
        }
      }
      .previewLayout(.sizeThatFits)
    }
}
  
