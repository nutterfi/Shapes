import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
/// A shape that paints everything in the frame except for the provided content.
public struct InvertedShape<Content: Shape>: Shape {
  
  /// The shape which will be removed from the final render
  public var shape: Content
  /// The inset value of the provided content to remove
  public var inset: CGFloat
  
  public var animatableData: CGFloat {
    get {
      inset
    }
    set {
      inset = newValue
    }
  }
  
  public init(shape: Content, inset: CGFloat = .zero) {
    self.shape = shape
    self.inset = inset
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      
      let framePath = Path(rect)
      let shapePath = shape.path(in: insetRect)
      let difference = framePath.cgPath.subtracting(shapePath.cgPath)
      
      path.addPath(Path(difference))
    }
  }
}


@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
extension Shape {
  @inlinable public func invert(inset: CGFloat = .zero) -> InvertedShape<Self> {
    InvertedShape(shape: self, inset: inset)
  }
}
