import SwiftUI

/// A proxy shape that makes any content conform to Insettable
struct InsettableWrapperShape<Content: Shape>: NFiShape {
  var shape: Content
  /// the secret sauce to insetting a shape
  var inset: CGFloat = .zero
  
  // conform to Shape
  func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    return shape.path(in: insetRect)
  }
}

#Preview {
  InsettableWrapperShape(shape: Diamond())
    .inset(by: 50)
}
