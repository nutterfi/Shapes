import SwiftUI

/// A circular sector, whose center lies in the center of the frame
public struct CircleSector: Shape {
  /// The starting angle of the sector
  public var startAngle: Angle
  
  /// The ending angle of the sector
  public var endAngle: Angle
  
  /// Whether to draw the sector clockwise
  public var clockwise: Bool = true
  
  /// Creates a new sector
  public init(startAngle: Angle, endAngle: Angle, clockwise: Bool = true) {
    self.startAngle = startAngle
    self.endAngle = endAngle
    self.clockwise = clockwise
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let radius = rect.breadth * 0.5
      path.move(to: rect.midXY)
      path.addArc(
        center: rect.midXY,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: !clockwise // SwiftUI coordinate system
      )
      path.closeSubpath()
    }
  }
}

struct CircleSector_Previews: PreviewProvider {
    static var previews: some View {
      CircleSector(startAngle: .zero, endAngle: .radians(.pi / 2))
        .padding()
    }
}
