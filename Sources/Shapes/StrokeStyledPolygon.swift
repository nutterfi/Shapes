//
//  StrokeStylePolygon.swift
//
//  Created by nutterfi on 8/3/21.
//

import SwiftUI

/// A helper view to provide an equally spaced stroke style to a polygon, using the view's frame
public struct StrokeStyledPolygon: View {
  /// the number of polygon sides
  public var sides: Int
  /// the number of dashes to apply to the polygon
  public var dashes: Int
  /// the density of a polygon determines whether it is drawn in a star or regular formation
  public var density: Int
  /// the percentage of each dash segment that is filled
  public var dashFillRatio: CGFloat
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat
  public var lineCap: CGLineCap = .round
  public var lineJoin: CGLineJoin = .miter
  /// determines the portion of the circle that is drawn
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
  
  public var body: some View {
    GeometryReader { proxy in
      let normalLineWidthRatio = lineWidthRatio.clamped(to: 0...CGFloat(0.5))
      let dim = min(proxy.size.width, proxy.size.height)
      let perimeter = CGFloat(sides) * dim * (1 - normalLineWidthRatio) * sin(.pi / CGFloat(sides))
      let strokeRatio: CGFloat =
      dashes > 0 ? perimeter / CGFloat(dashes) : 0
      ZStack {
        StarPolygon(points:sides, density: density)
          .inset(by: dim * normalLineWidthRatio * 0.5)
          .trim(from: trim.0, to: trim.1)
          .stroke(
            style: StrokeStyle(
              lineWidth: normalLineWidthRatio * dim,
              lineCap: lineCap,
              lineJoin: lineJoin,
              dash: [strokeRatio * dashFillRatio, strokeRatio * (1.0 - dashFillRatio)],
              dashPhase: strokeRatio * dashPhaseRatio
            )
          )
          .frame(width: dim, height: dim)
      }
      .frame(width: proxy.size.width, height: proxy.size.height)
    }
  }
}

public struct StrokeStylePolygon_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledPolygon(sides: 7, dashes: 7)
      .frame(width: 256, height: 256)
      .previewLayout(.sizeThatFits)
  }
}
