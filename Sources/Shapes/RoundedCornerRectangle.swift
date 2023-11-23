import SwiftUI

/// A rectangle with user-defined rounded corners.
@available(iOS, introduced: 15.0, deprecated: 16.0, message: "Use UnevenRoundedRectangle instead.")
@available(macOS, introduced: 12.0, deprecated: 14.0, message: "Use UnevenRoundedRectangle instead.")
@available(tvOS, introduced: 15.0, deprecated: 16.0, message: "Use UnevenRoundedRectangle instead.")
@available(watchOS, introduced: 8.0, deprecated: 10.0, message: "Use UnevenRoundedRectangle instead.")
@available(visionOS, deprecated: 1.0, message: "Use UnevenRoundedRectangle instead.")
public struct RoundedCornerRectangle: NFiShape {
  
  /// The defined corners of the rectangle
  public enum Corner : Sendable {
    case topLeft, topRight, bottomLeft, bottomRight
  }
  
  /// Defines which corners are applied with a corner radius
  public var corners: [Corner]
  
  /// The inset value
  public var inset: CGFloat = .zero
  
  /// The corner radius
  public var cornerRadius: CGFloat
  
  /// Creates a new rounded corner rectangle
  /// - Parameters:
  ///   - cornerRadius: The corner radius to apply to the specified corners
  ///   - corners: the corners to apply the corner radius
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
