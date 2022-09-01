//
//  StrokeStylePolygon.swift
//
//  Created by nutterfi on 8/3/21.
//

import SwiftUI

/// A polygon drawn with a stroke border, and a stroke style of equally distributed dashes.
public struct StrokeStyledPolygon: NFiShape {
  public var inset: CGFloat = .zero
  /// the number of polygon sides. Defaults to 3
  public var sides: Int
  
  /// the number of dashes to apply to the polygon
  public var dashes: Int
  
  /// the density of a polygon determines whether it is drawn in a star or regular formation. Defaults to 1.
  public var density: Int

  /// the percentage of each dash segment that is filled
  @available(*, deprecated, message: "segmentRatio is deprecated. Please use dashPattern")
  public var dashFillRatio: CGFloat = 0
  
  /// The weighted filled and unfilled regions of a single dash segment
  /// The input is normalized to be applied to each of the numberOfSegments to prevent discontinuities, so it will add up the total number and divide each by that total to get a percentage
  /// NOTE: Odd number of entries will result in appending a mirrored version of the array swapping the filled and unfilled portions
  /// Default value: [1, 1] (Equal weighted filled and unfilled regions)
  public var dashPattern: [CGFloat]
  
  /// the width of the stroked line as it relates to the frame size. Defaults to 0.01
  public var lineWidthRatio: CGFloat
  
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat = 0
  
  /// The endpoint style of a line.
  public var lineCap: CGLineCap = .round
  
  /// The join type of a line.
  public var lineJoin: CGLineJoin = .miter
  
  /// determines the trimmed portion of the polygon that is drawn
  public var trim: (CGFloat, CGFloat)
  
  public init(sides: Int = 3,
              dashes: Int = 10,
              density: Int = 1,
              dashPattern: [CGFloat] = [1, 1],
              lineWidthRatio: CGFloat = 0.01,
              dashPhaseRatio: CGFloat = 0,
              lineCap: CGLineCap = .round,
              lineJoin: CGLineJoin = .miter,
              trim: (CGFloat, CGFloat) = (0, 1)) {
    self.sides = sides
    self.dashes = dashes
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
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      
      let normalLineWidthRatio = lineWidthRatio.clamped(to: 0...CGFloat(0.5))
      
      let dim = min(insetRect.width, insetRect.height)
      
      let perimeter = CGFloat(sides) * dim * (1 - normalLineWidthRatio) * sin(.pi / CGFloat(sides))
      
      let strokeRatio: CGFloat =
      dashes > 0 ? perimeter / CGFloat(dashes) : 0
      
      let lineWidth = normalLineWidthRatio * dim
      
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
      
      path = StarPolygon(points: sides, density: density)
        .inset(by: lineWidth * 0.5)
        .trim(from: trim.0, to: trim.1)
        .path(in: insetRect)
        .strokedPath(style)
    }
  }
}

public struct StrokeStylePolygon_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledPolygon(
      sides: 5,
      dashes: 9,
      dashPattern: [2, 1, 3],
      lineWidthRatio: 0.01,
      lineCap: .butt,
      lineJoin: .miter
    )
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
