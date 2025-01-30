import SwiftUI

public struct Salinon: Shape {
  
  public var innerDiameterRatio: CGFloat
  public var centered: Bool
  
  public init(inset: CGFloat = .zero, innerDiameterRatio: CGFloat = 0.2, centered: Bool = false) {
    self.innerDiameterRatio = innerDiameterRatio
    self.centered = centered
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let dim = min(rect.width, rect.height)
      let center = CGPoint(x: rect.midX, y: rect.midY)
      
      // outer semicircle
      path.addArc(center: center, radius: dim * 0.5, startAngle: .radians(.pi), endAngle: .zero, clockwise: false)
      
      // AD and EB
      let outerDiameterRatio = (1.0 - innerDiameterRatio) * 0.5
      
      let pointB = path.currentPoint!
      
      let EBCenter = CGPoint(x: pointB.x - dim * outerDiameterRatio * 0.5, y: rect.midY)
      
      path.addArc(center: EBCenter, radius: dim * outerDiameterRatio * 0.5, startAngle: .zero, endAngle: .radians(.pi), clockwise: true)
      
      // DE arc
      path.addArc(center: center, radius: dim * innerDiameterRatio * 0.5, startAngle: .zero, endAngle: .radians(.pi / 2 ), clockwise: false)
      
      _ = path.currentPoint!  // Point 'F'
      
      path.addArc(center: center, radius: dim * innerDiameterRatio * 0.5, startAngle: .radians(.pi / 2 ), endAngle: .radians(.pi), clockwise: false)
      
      let pointD = path.currentPoint!  // Point 'D'
      
      let ADCenter = CGPoint(x: pointD.x - dim * outerDiameterRatio * 0.5, y: rect.midY)
      
      path.addArc(center: ADCenter, radius: dim * outerDiameterRatio * 0.5, startAngle: .zero, endAngle: .radians(.pi), clockwise: true)
      
      path.closeSubpath()
      
      if centered {
        let bounding = path.boundingRect
        let boundingDim = max(bounding.width, bounding.height)
        
        path = path
          .offsetBy(dx: rect.midX - bounding.midX, dy: rect.midY - bounding.midY)
          .scale(dim / boundingDim)
          .path(in: rect)
      }
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  // MARK: - Deprecations
  
  /// The inset amount of the shape
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public var inset: CGFloat = .zero
  
  @available(*, deprecated, message: "Use InsetShape or .inset(amount:) instead")
  public func inset(by amount: CGFloat) -> some InsettableShape {
    InsetShape(shape: self, inset: amount)
  }
}

struct SalinonDemo: View {
  @State private var ratio: CGFloat = 0.2
  @State private var inset: CGFloat = 0
  @State private var centered: Bool = false
  var body: some View {
    VStack {
      Slider(value: $ratio)
      Slider(value: $inset, in: 0.0...0.49, step: 0.01)
      Toggle("Centered", isOn: $centered)
      Spacer()
      Salinon(innerDiameterRatio: ratio, centered: centered)
        .inset(amount: inset * 128)
        .stroke(Color.red)
        .frame(width: 256, height: 128)
        .border(Color.purple)
      
      Salinon(innerDiameterRatio: ratio, centered: centered)
        .inset(amount: inset * 256)
        .stroke(Color.red)
        .frame(width: 256, height: 256)
        .border(Color.purple)
      
      Salinon(innerDiameterRatio: ratio, centered: centered)
        .inset(amount: inset * 128)
        .stroke(Color.red)
        .frame(width: 128, height: 256)
        .border(Color.purple)
      
      Spacer()
    }
  }
}

struct Salinon_Previews: PreviewProvider {
  static var previews: some View {
    SalinonDemo()
  }
}
