//
//  StrokeStyledRectangle.swift
//
//  Created by nutterfi on 8/3/21.
//

import SwiftUI

/// A rectangle drawn with a stroke border, and a stroke style of equally distributed dashes.
public struct StrokeStyledRectangle: NFiShape {
  
  public var inset: CGFloat = .zero
  
  // number of equal length dashes along the perimeter
  public var dashes: Int = 10
  
  /// the percentage of each dash segment that is filled
  public var dashFillRatio: CGFloat
  
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat
  
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat = 0
  
  public var lineCap: CGLineCap = .butt
  
  public var lineJoin: CGLineJoin = .miter
  
  /// determines the trimmed portion of the shape that is drawn
  public var trim: (CGFloat, CGFloat) = (0, 1)
  
  public init(dashes: Int = 4,
              dashFillRatio: CGFloat = 0.1,
              lineWidthRatio: CGFloat = 0.01,
              dashPhaseRatio: CGFloat = 0.36,
              lineCap: CGLineCap = .round,
              lineJoin: CGLineJoin = .miter,
              trim: (CGFloat, CGFloat) = (0, 1)) {
    self.dashes = dashes
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
      
      let perimeter = 2 * (insetRect.width + insetRect.height) * (1 - normalLineWidthRatio)
      
      let strokeRatio: CGFloat =
        dashes > 0 ? perimeter / CGFloat(dashes) : 0
      
      let lineWidth = dim * normalLineWidthRatio
      
      let style = StrokeStyle(
        lineWidth: lineWidth,
        lineCap: lineCap,
        lineJoin: lineJoin,
        dash: [strokeRatio * dashFillRatio, strokeRatio * (1.0 - dashFillRatio)],
        dashPhase: strokeRatio * dashPhaseRatio
      )
      
      path = Rectangle()
        .inset(by: lineWidth * 0.5)
        .trim(from: trim.0, to: trim.1)
        .path(in: insetRect)
        .strokedPath(style)
    }
  }
}

public struct StrokeStyledRectangle_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledRectangle(
      dashes: 30,
      dashFillRatio: 0.7,
      lineWidthRatio: 0.02
    )
      .foregroundColor(.purple)
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
