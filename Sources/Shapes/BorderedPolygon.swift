import SwiftUI

/// An inset polygon shape that supports styling via StrokeStyle.
/// This shape is an alternative to using `strokeBorder(style:antialiased:)` on `ConvexPolygon`.
/// FIXME: The combination of an odd repeatCount and odd dash pattern causes unexpected artifacts that can be seen when modifying the dash phase
public struct BorderedPolygon: Shape {
  public var sides: Int
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used to inset properly
  public var style: StrokeStyle

  /// How many times to repeat the pattern. A nonzero value normalizes the dash patterns to the size of the BorderedPolygon
  public var repeatCount: Double
  
  public init(_ sides: Int = 3, style: StrokeStyle = StrokeStyle(), repeatCount: Double = .zero) {
    self.sides = sides
    self.style = style
    self.repeatCount = repeatCount
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let theStyle = appliedStyle(in: rect)
      let polygonPath = InsetShape(shape: ConvexPolygon(sides: sides), inset: theStyle.lineWidth * 0.5)
        .path(in: rect)
        .strokedPath(theStyle)
      path.addPath(polygonPath)
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  /// Computes the required StrokeStyle to apply to the Path
  func appliedStyle(in rect: CGRect) -> StrokeStyle {
    // input validation
    let count = abs(repeatCount)

    var dash = style.dash
    var dashPhase = style.dashPhase
    
    let insetRect = rect.insetBy(dx: style.lineWidth * 0.5, dy: style.lineWidth * 0.5)
    
    let points = ConvexPolygon(sides: sides).vertices(in: insetRect)
    
    let sideLength = points[0].distance(to: points[1])
    
    let length = sideLength * Double(sides)
        
    if count > 0 {
      // normalized dash pattern
      let sum = dash.reduce(0, +)
      dash = dash.map {$0 * length / (sum * count)}
      dashPhase = dashPhase * length
    }
    
    return StrokeStyle(
      lineWidth: style.lineWidth,
      lineCap: style.lineCap,
      lineJoin: style.lineJoin,
      dash: dash,
      dashPhase: dashPhase
    )
  }
  
}

#Preview {
  BorderedPolygon(6, style: StrokeStyle(lineWidth: 25, lineCap: .round, dash: [1, 2, 3, 4]), repeatCount: 10)
}
