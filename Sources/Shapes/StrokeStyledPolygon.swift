//
//  StrokeStylePolygon.swift
//
//  Created by nutterfi on 8/3/21.
//

import SwiftUI

/// A polygon drawn with a stroke border, and a stroke style of equally distributed dashes.
public struct StrokeStyledPolygon: NFiShape {
  public var inset: CGFloat = .zero
  /// the number of polygon sides
  public var sides: Int = 3
  
  /// the number of dashes to apply to the polygon
  public var dashes: Int = 10
  
  /// the density of a polygon determines whether it is drawn in a star or regular formation
  public var density: Int = 1
  
  /// the percentage of each dash segment that is filled
  public var dashFillRatio: CGFloat = 0.8
  
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat = 0.1
  
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat = 0
  
  public var lineCap: CGLineCap = .round
  
  public var lineJoin: CGLineJoin = .miter
  
  /// determines the trimmed portion of the polygon that is drawn
  public var trim: (CGFloat, CGFloat) = (0, 1)
  
  public init(sides: Int,
              dashes: Int,
              density: Int = 1,
              dashFillRatio: CGFloat = 0.7,
              lineWidthRatio: CGFloat = 0.01,
              dashPhaseRatio: CGFloat = 0,
              lineCap: CGLineCap = .round,
              lineJoin: CGLineJoin = .miter,
              trim: (CGFloat, CGFloat) = (0, 1)) {
    self.sides = sides
    self.dashes = dashes
    self.density = density
    self.dashFillRatio = dashFillRatio
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
      
      let style = StrokeStyle(
        lineWidth: lineWidth,
        lineCap: lineCap,
        lineJoin: lineJoin,
        dash: [strokeRatio * dashFillRatio, strokeRatio * (1.0 - dashFillRatio)],
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
      sides: 8,
      dashes: 24,
      lineWidthRatio: 0.01
    )
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
