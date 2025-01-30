//
//  StrokeStyledRectangle.swift
//
//  Created by nutterfi on 8/3/21.
//

import SwiftUI

/// A rectangle drawn with a stroke border, and a stroke style of equally distributed dashes.
public struct StrokeStyledRectangle: Shape {
  // number of equal length dashes along the perimeter
  public var dashes: Int
  
  /// the percentage of each dash segment that is filled
  /// @available(*, deprecated, message: "segmentRatio is deprecated. Please use dashPattern")
  public var dashFillRatio: CGFloat = 0
  
  /// The weighted filled and unfilled regions of a single dash segment
  /// The input is normalized to be applied to each of the numberOfSegments to prevent discontinuities, so it will add up the total number and divide each by that total to get a percentage
  /// NOTE: Odd number of entries will result in appending a mirrored version of the array swapping the filled and unfilled portions
  /// Default value: [1, 1] (Equal weighted filled and unfilled regions)
  public var dashPattern: [CGFloat]
  
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat
  
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat = 0
  
  /// The endpoint style of a line.
  public var lineCap: CGLineCap = .butt
  
  /// The join type of a line.
  public var lineJoin: CGLineJoin = .miter
  
  /// determines the trimmed portion of the shape that is drawn
  public var trim: (CGFloat, CGFloat) = (0, 1)
  
  public init(dashes: Int = 4,
              dashPattern: [CGFloat] = [1, 1],
              lineWidthRatio: CGFloat = 0.01,
              dashPhaseRatio: CGFloat = 0,
              lineCap: CGLineCap = .round,
              lineJoin: CGLineJoin = .miter,
              trim: (CGFloat, CGFloat) = (0, 1)) {
    self.dashes = dashes
    self.dashPattern = dashPattern
    self.lineWidthRatio = lineWidthRatio
    self.dashPhaseRatio = dashPhaseRatio
    self.lineCap = lineCap
    self.lineJoin = lineJoin
    self.trim = trim
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in      
      let normalLineWidthRatio = lineWidthRatio.clamped(to: 0...CGFloat(0.5))
      
      let dim = min(rect.width, rect.height)
      
      let perimeter = 2 * (rect.width + rect.height) * (1 - normalLineWidthRatio)
      
      let strokeRatio: CGFloat =
      dashes > 0 ? perimeter / CGFloat(dashes) : 0
      
      let lineWidth = dim * normalLineWidthRatio
      
      var validatedDashPattern: [CGFloat] = dashPattern
      if dashPattern.count % 2 != 0 , dashes % 2 != 0 {
        validatedDashPattern.append(contentsOf: dashPattern)
      }
      
      let total = validatedDashPattern.reduce(0, +)
      
      let normalizedDashPattern = validatedDashPattern.map {$0 * strokeRatio / total }
      
      let style = StrokeStyle(
        lineWidth: lineWidth,
        lineCap: lineCap,
        lineJoin: lineJoin,
        dash: normalizedDashPattern,
        dashPhase: strokeRatio * dashPhaseRatio
      )
      
      path = Rectangle()
        .inset(by: lineWidth * 0.5)
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

public struct StrokeStyledRectangle_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledRectangle(
      dashes: 16,
      dashPattern: [2, 1, 3],
      lineWidthRatio: 0.01,
      lineCap: .butt,
      lineJoin: .miter
    )
    .foregroundColor(.purple)
    .frame(width: 256, height: 256)
    .previewLayout(.sizeThatFits)
  }
}
