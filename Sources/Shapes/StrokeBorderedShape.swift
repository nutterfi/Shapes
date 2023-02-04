import SwiftUI

extension Shape {
  
  // returns a Shape that has applied a strokeBorder effect with a given lineWidth and the default StrokeStyle parameters. Applies an optional trim effect.
  public func strokeBordered(_ lineWidth: CGFloat = 1, trim: (CGFloat, CGFloat) = (.zero, 1.0)) -> some Shape {
    StrokeBorderedShape(shape: self, trim: trim, style: StrokeStyle(lineWidth: lineWidth))
  }
  
  // returns a Shape that has applied a strokeBorder effect with a given StrokeStyle. Applies an optional trim effect.
  public func strokeBordered(_ style: StrokeStyle, trim: (CGFloat, CGFloat) = (.zero, 1.0)) -> some Shape {
    StrokeBorderedShape(shape: self, trim: trim, style: style)
  }
}

/// A wrapper type that provides the capabilities of InsettableShape's strokeBorder methods (excluding ShapeStyle) without converting the Shape to a View
public struct StrokeBorderedShape<Content: Shape>: Shape {
  /// the Shape to apply the strokeBordered effect (does not need to be Insettable)
  public var shape: Content
  
  /// trim values to apply to the stroked shape
  public var trim: (CGFloat, CGFloat) = (.zero, 1.0)
  
  /// the StrokeStyle to be used when drawing the path
  public var style: StrokeStyle = StrokeStyle()
  
  public init(shape: Content, trim: (CGFloat, CGFloat) = (.zero, 1.0), style: StrokeStyle = StrokeStyle()) {
    self.shape = shape
    self.trim = trim
    self.style = style
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: style.lineWidth / 2, dy: style.lineWidth / 2)
    return shape
      .path(in: insetRect)
      .trimmedPath(from: trim.0, to: trim.1)
      .strokedPath(style)
  }
}
