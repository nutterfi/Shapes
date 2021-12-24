//
//  StrokeStyledRectangle.swift
//
//  Created by nutterfi on 8/3/21.
//

import SwiftUI

/// A helper view to provide an equally spaced stroke style to a rectangle, using the view's frame
public struct StrokeStyledRectangle: View {
  // number of equal length dashes along the perimeter
  public var dashes: Int
  /// the percentage of each dash segment that is filled
  public var dashFillRatio: CGFloat
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat
  public var lineCap: CGLineCap
  public var lineJoin: CGLineJoin
  /// determines the portion of the circle that is drawn
  public var trim: (CGFloat, CGFloat)
  
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
  
  public var body: some View {
    GeometryReader { proxy in
      let normalLineWidthRatio = lineWidthRatio.clamped(to: 0...CGFloat(0.5))
      let dim = min(proxy.size.width, proxy.size.height)
      let perimeter = 2 * (proxy.size.width + proxy.size.height) * (1 - normalLineWidthRatio)
      let strokeRatio: CGFloat =
      dashes > 0 ? perimeter / CGFloat(dashes) : 0
      ZStack {
        Rectangle()
          .inset(by: dim * normalLineWidthRatio * 0.5)
          .trim(from: trim.0, to: trim.1)
          .stroke(
            style: StrokeStyle(
              lineWidth: dim * normalLineWidthRatio,
              lineCap: lineCap,
              lineJoin: lineJoin,
              dash: [strokeRatio * dashFillRatio, strokeRatio * (1.0 - dashFillRatio)],
              dashPhase: strokeRatio * dashPhaseRatio
            )
          )
      }
      .frame(width: proxy.size.width, height: proxy.size.height)
    }
  }
}

public struct StrokeStyledRectangle_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledRectangle(dashes: 30,
                          dashFillRatio: 0.7,
                          lineWidthRatio: 0.02)
      .foregroundColor(.purple)
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
