import SwiftUI

public struct Teardrop: NFiShape {
  
  public var inset: CGFloat = .zero
    
  /// clamped values between 0...1 Default is CGPoint(1,0.5)
  public var variation: CGPoint
  
  public init(_ variation: CGPoint = CGPoint(x: CGFloat(1), y: CGFloat(0.5))) {
    let x = variation.x.clamped(to: CGFloat(0.0)...CGFloat(1.0))
    let y = variation.y.clamped(to: CGFloat(0.0)...CGFloat(1.0))
    self.variation = CGPoint(x: x, y: y)
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    let dim = min(insetRect.width, insetRect.height)
    let origin = CGPoint(x: insetRect.midX, y: insetRect.minY)
    
    let controlPoint1 = CGPoint(
      x: insetRect.midX + dim * 0.5 * variation.x,
      y: insetRect.minY + insetRect.height * 0.5 * variation.y
    )
    
    let controlPoint2 = CGPoint(
      x: insetRect.midX - dim * 0.5 * variation.x,
      y: insetRect.minY + insetRect.height * 0.5 * variation.y
    )
    
    return Path { path in
      path.move(to: origin)
      
      path.addQuadCurve(
        to: CGPoint(
          x: insetRect.midX + dim * 0.5,
          y: insetRect.maxY - dim * 0.5
        ),
        control: controlPoint1
      )
      
      path.addArc(
        center: .init(x: insetRect.midX, y: insetRect.maxY - dim * 0.5),
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
          .strokeBorder(Color.red,
                        style: StrokeStyle(
                          lineWidth: 2,
                          lineCap: .round,
                          lineJoin: .round)
          )
        
          .frame(width: 150, height: 300)
          .border(Color.purple)
        Teardrop(CGPoint(x: CGFloat(xValue), y: CGFloat(yValue)))
          .inset(by: 80)
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
