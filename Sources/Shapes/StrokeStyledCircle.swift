//
//  StrokeStyledCircle.swift
//
//  Created by nutterfi on 7/12/21.
//

import SwiftUI

/// A circle drawn with a stroke border, and a stroke style of equally distributed dashes.
public struct StrokeStyledCircle: NFiShape {
  
  /// the amount of inset to apply to the shape
  public var inset: CGFloat = .zero
  
  /// the number of dashes used to stroke the circle path
  public var numberOfSegments: Int
  
  /// the percentage of each dash to fill
  @available(*, deprecated, message: "segmentRatio is deprecated. Please use dashPattern")
  public var segmentRatio: CGFloat = 0

  /// The weighted filled and unfilled regions of a single dash segment
  /// The input is normalized to be applied to each of the numberOfSegments to prevent discontinuities, so it will add up the total number and divide each by that total to get a percentage
  /// NOTE: Odd number of entries will result in appending a mirrored version of the array swapping the filled and unfilled portions
  /// Default value: [1, 1] (Equal weighted filled and unfilled regions)
  public var dashPattern: [CGFloat]
  
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat
  
  /// determines the portion of the circle that is drawn
  public var trim: (from: CGFloat, to: CGFloat)
  
  /// The endpoint style of a line.
  public var lineCap: CGLineCap = .butt
  
  /// The join type of a line.
  public var lineJoin: CGLineJoin = .miter
  
  /// A threshold used to determine whether to use a bevel instead of a
  /// miter at a join.
  public var miterLimit: CGFloat = 0
  
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat = 0.0
  
  public init(
    numberOfSegments: Int = 12,
    dashPattern: [CGFloat] = [1, 1],
    lineWidthRatio: CGFloat = 0.1,
    trim: (from: CGFloat, to: CGFloat) = (0, 1),
    lineCap: CGLineCap = .butt,
    lineJoin: CGLineJoin = .miter,
    miterLimit: CGFloat = 0,
    dashPhaseRatio: CGFloat = 0
  ) {
    self.numberOfSegments = numberOfSegments
    self.dashPattern = dashPattern
    self.lineWidthRatio = lineWidthRatio
    self.trim = trim
    self.lineCap = lineCap
    self.lineJoin = lineJoin
    self.miterLimit = miterLimit
    self.dashPhaseRatio = dashPhaseRatio
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      
      let dim = min(insetRect.width, insetRect.height)
      
      // Circumference of the circle split into the number of dashes gives the length of a single dash
      let dashLength: CGFloat = .pi * dim / CGFloat(numberOfSegments)
      
      // A strokeBorder is limited to 50% of the circle diameter
      let normalLineWidthRatio = lineWidthRatio.clamped(to: 0.0...CGFloat(0.5))
      
      // strokeRatio depends on path length
      let strokeRatio: CGFloat = dashLength * (1.0 - normalLineWidthRatio)
      
      let lineWidth = dim * normalLineWidthRatio
      
      var validatedDashPattern: [CGFloat] = dashPattern
      if dashPattern.count % 2 != 0 , numberOfSegments % 2 != 0 {
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
      
      // the inset followed by the strokedPath results in a strokeBorder style. The trim placement is required so that the circle border is what is trimmed, rather than the entire shape.
      path = Circle()
        .inset(by: lineWidth * 0.5)
        .trim(from: trim.0, to: trim.1)
        .path(in: insetRect)
        .strokedPath(style)
    }
  }
}

public struct StrokeStyledCircle_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledCircle(
      numberOfSegments: 5,
      dashPattern: [5, 1, 2],
      lineWidthRatio: 0.2
    )
    .frame(width: 256, height: 256)
    .previewLayout(.sizeThatFits)
  }
}
