//
//  StrokeStyledCircle.swift
//
//  Created by nutterfi on 7/12/21.
//

import SwiftUI

/// A helper view to provide an equally spaced stroke style to a circle, using the view's frame
public struct StrokeStyledCircle: View {
  
  public var numberOfSegments: Int
  /// the percentage of each segment that is filled
  public var segmentRatio: CGFloat
  /// the width of the stroked line as it relates to the frame size
  public var lineWidthRatio: CGFloat
  /// determines the portion of the circle that is drawn
  public var trim: (CGFloat, CGFloat)
  /// applied with lineWidthRatio to obtain a continuous phase offset across the perimeter of the shape
  public var dashPhaseRatio: CGFloat
    
  public init(numberOfSegments: Int = 4,
              segmentRatio: CGFloat = 0.9,
              lineWidthRatio: CGFloat = 0.1,
              trim: (CGFloat, CGFloat) = (0, 1),
              dashPhaseRatio: CGFloat = 1.0) {
    self.numberOfSegments = numberOfSegments
    self.segmentRatio = segmentRatio
    self.lineWidthRatio = lineWidthRatio
    self.trim = trim
    self.dashPhaseRatio = dashPhaseRatio
  }
  
  public var body: some View {
    GeometryReader { proxy in
      let normalLineWidthRatio = lineWidthRatio.clamped(to: 0...CGFloat(0.5))
      let dim = min(proxy.size.width, proxy.size.height)
      let strokeRatio: CGFloat = .pi * dim * (1 - normalLineWidthRatio) / CGFloat(numberOfSegments)
      ZStack {
        Circle()
          .inset(by: dim * normalLineWidthRatio * 0.5)
          .trim(from: trim.0, to: trim.1)
          .stroke(
            style: StrokeStyle(
              lineWidth: normalLineWidthRatio * dim,
              dash: [strokeRatio * segmentRatio, strokeRatio * (1.0 - segmentRatio)],
              dashPhase: strokeRatio * dashPhaseRatio
            )
          )
          .frame(width: dim, height: dim)
      }
      .frame(width: proxy.size.width, height: proxy.size.height)
    }
  }
}

public struct StrokeStyledCircle_Previews: PreviewProvider {
  public static var previews: some View {
    StrokeStyledCircle(numberOfSegments: 5, segmentRatio: 0.8, lineWidthRatio: 0.5)
  }
}
