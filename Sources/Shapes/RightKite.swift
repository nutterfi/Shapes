import SwiftUI

/// A kite where points are placed along a circle
public struct RightKite: Polygon {
  public var inset: CGFloat = .zero
  
  public var sides: Int = 4
  
  /// Ratio between 0 and pi for the placement of the kite points around the circle
  public var pointRatio: CGFloat = 0.5
  
  public init(pointRatio: CGFloat) {
    self.pointRatio = pointRatio
  }
  
  public func vertices(in rect: CGRect) -> [CGPoint] {
    let r = min(rect.size.width, rect.size.height) / 2
    let origin = CGPoint(x: rect.midX, y: rect.midY)
    
    let theta = .pi * pointRatio
    let point = CGPoint(x: origin.x + r * cos(theta - .pi / 2), y: origin.y + r * sin(theta - .pi / 2))
    let pointPrime = CGPoint(x: origin.x + r * cos(-theta - .pi / 2), y: origin.y + r * sin(-theta - .pi / 2))
    
    return [
      CGPoint(x: origin.x + r * cos(-.pi / 2), y: origin.y + r * sin(-.pi / 2)),
      point,
      CGPoint(x: origin.x + r * cos(.pi - .pi/2), y: origin.y + r * sin(.pi - .pi/2)),
      pointPrime
    ]
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.addLines(vertices(in: insetRect))
      path.closeSubpath()
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
}

extension RightKite: Animatable {
  public var animatableData: CGFloat {
    get {
      pointRatio
    }
    set {
      pointRatio = newValue
    }
  }
}

struct RightKite_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      Circle().stroke()
      RightKite(pointRatio: 0.25)
        .inset(by: 50)
        .stroke()
      Circle()
        .inset(by: 50)
        .stroke()

    }
    .frame(width: 512, height: 256)
  }
}
