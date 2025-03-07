import SwiftUI

public struct Salinon: Shape {
  
  public var innerDiameterRatio: CGFloat
  
  public init(inset: CGFloat = .zero, innerDiameterRatio: CGFloat = 0.2) {
    self.innerDiameterRatio = innerDiameterRatio
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let dim = rect.breadth
      let center = rect.midXY
      
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
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
}

private struct SalinonDemo: View {
  @State private var ratio: CGFloat = 0.2
  @State private var inset: CGFloat = 0
  var body: some View {
    VStack {
      Slider(value: $ratio)
      Slider(value: $inset, in: 0.0...0.49, step: 0.01)
      Spacer()
      Salinon(innerDiameterRatio: ratio)
        .inset(amount: inset * 128)
        .stroke(Color.red)
        .frame(width: 256, height: 128)
        .border(Color.purple)
      
      Salinon(innerDiameterRatio: ratio)
        .inset(amount: inset * 256)
        .stroke(Color.red)
        .frame(width: 256, height: 256)
        .border(Color.purple)
      
      Salinon(innerDiameterRatio: ratio)
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
