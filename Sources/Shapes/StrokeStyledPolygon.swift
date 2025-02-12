import SwiftUI

/// A polygon drawn with a stroke border, and a stroke style of equally distributed dashes.
public struct StrokeStyledPolygon: Shape {
  /// the number of polygon sides. Defaults to 3
  public var sides: Int
  
  /// the number of dash patterns to apply to the polygon. Defaults to 10.
  public var dashPatternCount: Int
  
  /// the density of a polygon determines whether it is drawn in a star or regular formation. Defaults to 1.
  public var density: Int
  
  /// The weighted filled and unfilled regions of a single dash segment
  /// The input is normalized to be applied to each of the sides(TODO: Verify) to prevent discontinuities, so it will add up the total number and divide each by that total to get a percentage
  /// NOTE: Odd number of entries will result in appending a mirrored version of the array swapping the filled and unfilled portions
  /// Default value: [1, 1] (Equal weighted filled and unfilled regions)
  public var dashPattern: [CGFloat]
  
  /// the width of the stroked line as it relates to the frame size. Defaults to 0.01
  public var lineWidthRatio: CGFloat?
  
  /// the width of the stroked line, in points
  public var lineWidth: CGFloat?
  
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat = .zero
  
  /// The endpoint style of a line.
  public var lineCap: CGLineCap = .round
  
  /// The join type of a line.
  public var lineJoin: CGLineJoin = .miter
  
  /// determines the trimmed portion of the polygon that is drawn
  public var trim: (CGFloat, CGFloat)
  
  public init(
    sides: Int = 3,
    dashPatternCount: Int = 10,
    density: Int = 1,
    dashPattern: [CGFloat] = [1, 1],
    lineWidth: CGFloat = 1,
    dashPhaseRatio: CGFloat = 0,
    lineCap: CGLineCap = .round,
    lineJoin: CGLineJoin = .miter,
    trim: (CGFloat, CGFloat) = (0, 1)
  ) {
    self.sides = sides
    self.dashPatternCount = dashPatternCount
    self.density = density
    self.dashPattern = dashPattern
    self.lineWidth = lineWidth
    self.dashPhaseRatio = dashPhaseRatio
    self.lineCap = lineCap
    self.lineJoin = lineJoin
    self.trim = trim
  }
  
  public init(
    sides: Int = 3,
    dashPatternCount: Int = 10,
    density: Int = 1,
    dashPattern: [CGFloat] = [1, 1],
    lineWidthRatio: CGFloat = 0.01,
    dashPhaseRatio: CGFloat = 0,
    lineCap: CGLineCap = .round,
    lineJoin: CGLineJoin = .miter,
    trim: (CGFloat, CGFloat) = (0, 1)
  ) {
    self.sides = sides
    self.dashPatternCount = dashPatternCount
    self.density = density
    self.dashPattern = dashPattern
    self.lineWidthRatio = lineWidthRatio
    self.dashPhaseRatio = dashPhaseRatio
    self.lineCap = lineCap
    self.lineJoin = lineJoin
    self.trim = trim
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let dim = min(rect.width, rect.height)
      
      let strokeWidth: CGFloat
      let strokeRatio: CGFloat
      
      if let lineWidth = lineWidth {
        strokeWidth = lineWidth
        
        let perimeter = CGFloat(sides) * dim * sin(.pi / CGFloat(sides))
        
        let dashLength: CGFloat = perimeter / CGFloat(dashPatternCount)
        
        strokeRatio = dashLength * (1 - strokeWidth / dim)
      } else if let lineWidthRatio = lineWidthRatio {
        
        let clampedLineWidthRatio = lineWidthRatio.clamped(to: 0.0...CGFloat(0.5))
        
        let perimeter = CGFloat(sides) * dim * (1 - clampedLineWidthRatio) * sin(.pi / CGFloat(sides))
        
        strokeRatio = dashPatternCount > 0 ? perimeter / CGFloat(dashPatternCount) : 0
                
        strokeWidth = dim * clampedLineWidthRatio
      } else { // this should not happen
        strokeWidth = 1
        strokeRatio = 1
      }
      
      var validatedDashPattern: [CGFloat] = dashPattern
      if dashPattern.count % 2 != 0 , dashPatternCount % 2 != 0 {
        validatedDashPattern.append(contentsOf: dashPattern)
      }
      
      let total = validatedDashPattern.reduce(0, +)
      
      let normalizedDashPattern = validatedDashPattern.map {$0 * strokeRatio / total }
      
      let style = StrokeStyle(
        lineWidth: strokeWidth,
        lineCap: lineCap,
        lineJoin: lineJoin,
        dash: normalizedDashPattern,
        dashPhase: strokeRatio * dashPhaseRatio
      )
      
      path = StarPolygon(points: sides, density: density)
        .inset(amount: strokeWidth * 0.5)
        .trim(from: trim.0, to: trim.1)
        .path(in: rect)
        .strokedPath(style)
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

public struct StrokeStylePolygon_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledPolygon(
      sides: 5,
//      dashPatternCount: 4,
//      dashPattern: [1,1],
      lineWidth: 1,
      lineCap: .butt,
      lineJoin: .miter
    )
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
