import SwiftUI

public struct Teardrop: Shape {

  /// clamped values between 0...1 Default is CGPoint(1,0.5)
  public var variation: CGPoint
  
  public init(_ variation: CGPoint = CGPoint(x: CGFloat(1), y: CGFloat(0.5))) {
    let x = variation.x.clamped(to: CGFloat(0.0)...CGFloat(1.0))
    let y = variation.y.clamped(to: CGFloat(0.0)...CGFloat(1.0))
    self.variation = CGPoint(x: x, y: y)
  }
  
  public func path(in rect: CGRect) -> Path {
    let dim = min(rect.width, rect.height)
    let origin = CGPoint(x: rect.midX, y: rect.minY)
    
    let controlPoint1 = CGPoint(
      x: rect.midX + dim * 0.5 * variation.x,
      y: rect.minY + rect.height * 0.5 * variation.y
    )
    
    let controlPoint2 = CGPoint(
      x: rect.midX - dim * 0.5 * variation.x,
      y: rect.minY + rect.height * 0.5 * variation.y
    )
    
    return Path { path in
      path.move(to: origin)
      
      path.addQuadCurve(
        to: CGPoint(
          x: rect.midX + dim * 0.5,
          y: rect.maxY - dim * 0.5
        ),
        control: controlPoint1
      )
      
      path.addArc(
        center: .init(x: rect.midX, y: rect.maxY - dim * 0.5),
        radius: dim * 0.5,
        startAngle: .zero,
        endAngle: Angle(radians: .pi),
        clockwise: false)
      
      path.addQuadCurve(
        to: origin,
        control: controlPoint2
      )
      
      path.closeSubpath()
    }
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

struct TeardropDemo: View {
  @State private var xValue: CGFloat = 0.0
  @State private var yValue: CGFloat = 0.0
  
  var body: some View {
    VStack {
      Slider(value: $xValue)
      Slider(value: $yValue)
      Spacer()
      ZStack {
        Teardrop(CGPoint(x: CGFloat(xValue), y: CGFloat(yValue)))
          .inset(amount: 0)
          .strokeBorder(Color.red,
                        style: StrokeStyle(
                          lineWidth: 2,
                          lineCap: .round,
                          lineJoin: .round)
          )
        
          .frame(width: 150, height: 300)
          .border(Color.purple)
        Teardrop(CGPoint(x: CGFloat(xValue), y: CGFloat(yValue)))
          .inset(amount: 80)
          .strokeBorder(Color.red,
                        style: StrokeStyle(
                          lineWidth: 2,
                          lineCap: .round,
                          lineJoin: .round)
          )
          .frame(width: 150, height: 300)
          .border(Color.purple)
      }
      Spacer()
    }
  }
}

struct Teardrop_Previews: PreviewProvider {
    static var previews: some View {
      TeardropDemo()
    }
}
