//
//  BorderedRectangle.swift
//  book-swiftui-shapes-examples
//
//  Created by nutterfi on 9/2/23.
//

import SwiftUI

/// An inset rectangular shape that supports styling via StrokeStyle.
/// This shape is an alternative to using `strokeBorder(style:antialiased:)` on `Rectangle`.
public struct BorderedRectangle: Shape {
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used to inset properly
  public var style: StrokeStyle

  /// How many times to repeat the pattern. A nonzero value normalizes the dash patterns to the size of the BorderedRectangle
  public var repeatCount: Double
  
  public init(style: StrokeStyle = StrokeStyle(), repeatCount: Double = .zero) {
    self.style = style
    self.repeatCount = repeatCount
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let theStyle = appliedStyle(in: rect)
      let rectanglePath = Rectangle()
        .inset(by: theStyle.lineWidth * 0.5)
        .path(in: rect)
        .strokedPath(theStyle)
      path.addPath(rectanglePath)
    }
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Rectangle().sizeThatFits(proposal)
  }
  
  /// Computes the required StrokeStyle to apply to the Path
  func appliedStyle(in rect: CGRect) -> StrokeStyle {
    // input validation
    let count = abs(repeatCount)

    var dash = style.dash
    var dashPhase = style.dashPhase
    
    let insetRect = rect.insetBy(dx: style.lineWidth * 0.5, dy: style.lineWidth * 0.5)
    
    let length = 2 * (insetRect.width + insetRect.height)
        
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
  BorderedRectangle()
}
