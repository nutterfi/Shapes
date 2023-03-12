import SwiftUI

public struct RoundedCornerRectangle: NFiShape {
  
  public enum Corner {
    case topLeft, topRight, bottomLeft, bottomRight
  }
  
  public var corners: [Corner]
  public var inset: CGFloat = .zero
  
  public var cornerRadius: CGFloat
  
  public init(cornerRadius: CGFloat, corners: [Corner] = [.topLeft, .topRight, .bottomLeft, .bottomRight]) {
    self.cornerRadius = cornerRadius
    self.corners = corners
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    let dim = min(insetRect.width, insetRect.height)
    let safeCornerRadius = min(cornerRadius, dim * 0.5)
    
    return Path { path in
      // starting point
      path.move(to: CGPoint(x: insetRect.minX, y: insetRect.minY + safeCornerRadius))
      
      if corners.contains(.topLeft) {
        path.addArc(center: CGPoint(x: insetRect.minX + safeCornerRadius, y: insetRect.minY + safeCornerRadius), radius: CGFloat(safeCornerRadius), startAngle: .init(radians: .pi), endAngle: .init(radians: -.pi / 2), clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.minY))
      }
      
      // draw line to the right
      path.addLine(to: CGPoint(x: insetRect.maxX - CGFloat(safeCornerRadius), y: insetRect.minY))
      
      if corners.contains(.topRight) {
        path.addArc(center: CGPoint(x: insetRect.maxX - safeCornerRadius, y: insetRect.minY + safeCornerRadius), radius: CGFloat(safeCornerRadius), startAngle: .init(radians: -.pi/2), endAngle: .zero, clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.minY))
      }
      
      // draw line down
      path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY - CGFloat(safeCornerRadius)))
      
      if corners.contains(.bottomRight) {
        path.addArc(center: CGPoint(x: insetRect.maxX - safeCornerRadius, y: insetRect.maxY - safeCornerRadius), radius: CGFloat(safeCornerRadius), startAngle: .zero, endAngle: .init(radians: .pi / 2), clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY))
      }
      
      
      // draw line left
      path.addLine(to: CGPoint(x: insetRect.minX + CGFloat(safeCornerRadius), y: insetRect.maxY))
      
      if corners.contains(.bottomLeft) {
        path.addArc(center: CGPoint(x: insetRect.minX + safeCornerRadius, y: insetRect.maxY - safeCornerRadius), radius: CGFloat(safeCornerRadius), startAngle: .init(radians: .pi / 2), endAngle: .init(radians: .pi), clockwise: false)
      } else {
        path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.maxY))
      }
      
      // draw line up
      path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.minY + safeCornerRadius))
      path.closeSubpath()
    }
  }
  
}

struct RoundedCornerRectangle_Previews: PreviewProvider {
  static var previews: some View {
    Group {
      RoundedCornerRectangle(cornerRadius: 32, corners: [.topLeft, .topRight, .bottomRight])
      
      RoundedCornerRectangle(cornerRadius: 120, corners: [ .topRight, .bottomLeft])
        .stroke()
        .padding()
    }
    .previewLayout(.sizeThatFits)
    .frame(width: 128, height: 256)
  }
}
