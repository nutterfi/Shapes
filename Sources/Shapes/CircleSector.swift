import SwiftUI

/// A circular sector, whose center lies in the center of the frame
public struct CircleSector: Shape {
  public var startAngle: Angle
  public var endAngle: Angle
  public var clockwise: Bool = true
  
  public init(startAngle: Angle, endAngle: Angle, clockwise: Bool = true) {
    self.startAngle = startAngle
    self.endAngle = endAngle
    self.clockwise = clockwise
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let radius = min(rect.width, rect.height) * 0.5
      path.move(to: rect.mid)
      path.addArc(
        center: rect.mid,
        radius: radius,
        startAngle: startAngle,
        endAngle: endAngle,
        clockwise: clockwise
      )
      path.closeSubpath()
    }
  }
}

struct CircleSector_Previews: PreviewProvider {
    static var previews: some View {
      CircleSector(startAngle: .zero, endAngle: .radians(.pi))
    }
}
