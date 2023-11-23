import CoreGraphics

public extension CGRect {
  /// The minimum point in both x and y dimensions
  var min: CGPoint {
    CGPoint(x: minX, y: minY)
  }
  
  /// The middle point in both x and y dimensions
  var mid: CGPoint {
    CGPoint(x: midX, y: midY)
  }
  
  /// The maximum point in both x and y dimensions
  var max: CGPoint {
    CGPoint(x: maxX, y: maxY)
  }
  
  /// constructs an array of `CGRect` instances in a 2D grid fashion that fit inside the original rectangle
  func subdivide(rows: Double, columns: Double) -> [CGRect] {
    var rects = [CGRect]()
    let dx = width / Double(columns)
    let dy = height / Double(rows)
    let size = CGSize(width: dx, height: dy)
    
    for row in 0..<Int(rows) {
      for column in 0..<Int(columns) {
        let origin = CGPoint(
          x: minX + CGFloat(column) * dx,
          y: minY + CGFloat(row) * dy
        )
        let item = CGRect(origin: origin, size: size)
        
        rects.append(item)
      }
    }
    return rects
  }
}
