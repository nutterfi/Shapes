import SwiftUI

extension CGRect {
  
  /// Adjusts a rectangle by the given edge insets. Valid for LTR layout directions only.
  /// TODO: Support for RTL
  public func inset(by insets: EdgeInsets) -> CGRect {
    let newOrigin = origin.offsetBy(dx: insets.leading, dy: insets.top)
    let newSize: CGSize = CGSize(
      width: width - insets.trailing - insets.leading,
      height: height - insets.bottom - insets.top
    )
    
    return CGRect(origin: newOrigin, size: newSize)
  }
}

@available(*, deprecated, renamed: "InsetShape", message: "Renamed InsetShape")
typealias InsettableWrapperShape = InsetShape

/// A shape with an inset applied to it.
public struct InsetShape<Content: Shape>: InsettableShape {
  
  /// the target shape
  public var shape: Content
  
  /// the inset amounts
  public var insets: EdgeInsets
    
  /// Create a new inset shape.
  public init(shape: Content, inset: CGFloat) {
    self.shape = shape
    self.insets = EdgeInsets(top: inset, leading: inset, bottom: inset, trailing: inset)
  }
  
  public init(shape: Content, insets: EdgeInsets) {
    self.shape = shape
    self.insets = insets
  }
  
  public func inset(by amount: CGFloat) -> some InsettableShape {
    var me = self
    me.insets = EdgeInsets(top: amount, leading: amount, bottom: amount, trailing: amount)
    return me
  }
  
  public func path(in rect: CGRect) -> Path {
    return shape.path(in: rect.inset(by: insets))
  }
}

public extension Shape {
  /// Insets this shape by an amount you specify.
  func inset(amount: CGFloat) -> InsetShape<Self> {
    InsetShape(shape: self, inset: amount)
  }
  
  /// Insets this shape by the amounts you specify.
  func inset(by insets: EdgeInsets) -> InsetShape<Self> {
    InsetShape(shape: self, insets: insets)
  }
}

#Preview("Shape Inset Mod") {
  
  struct Demo: View {
    @State private var insets: EdgeInsets = .init()
    
    var body: some View {
      
      VStack {
        
        Text("TOP")
        Slider(value: $insets.top, in: 0...100)
        Text("LEADING")
        Slider(value: $insets.leading, in: 0...100)
        Text("BOTTOM")
        Slider(value: $insets.bottom, in: 0...100)
        Text("TRAILING")
        Slider(value: $insets.trailing, in: 0...100)
        
        Diamond()
          .inset(by: insets)
          .border(Color.blue)
          .frame(width: 100, height: 100)
      }
      .padding()
    }
  }
  
  return Demo()
}
