import SwiftUI

@available(*, deprecated, renamed: "InsetShape", message: "Renamed InsetShape")
typealias InsettableWrapperShape = InsetShape

/// A shape with an inset applied to it. Insets can be differing values for each rectangle edge
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
  
  /// Create a new inset shape.
  public init(shape: Content, insets: EdgeInsets) {
    self.shape = shape
    self.insets = insets
  }
  
  /// Returns an shape inset by equal amounts on each side.
  public func inset(by amount: CGFloat) -> some InsettableShape {
    var me = self
    me.insets = EdgeInsets(top: amount, leading: amount, bottom: amount, trailing: amount)
    return me
  }
  
  public func path(in rect: CGRect) -> Path {
    return shape.path(in: rect.inset(by: insets))
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    shape.sizeThatFits(proposal)
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

#Preview("Inset Test") {
  struct Demo: View {
    @State private var inset: CGFloat = .zero
    
    let maximum: CGFloat = 200
    
    var body: some View {
      VStack(spacing: 20) {
        Text(inset.description)
        Slider(value: $inset, in: -100...maximum, step: 10)
        
        let shape = Rectangle()
        
        let old = shape
          .inset(by: inset)
        
        old
          .fill(Color.red.opacity(0.5))
          .overlay(
            old
              .stroke(lineWidth: 3)
          )
          .overlay(
            Text(old.path(in: CGRect.square(maximum))
              .description)
              .foregroundStyle(.white)
          )
          .background(
            Check(rows: 4, columns: 4)
              .background(Color.gray)
              .opacity(0.5)
          )
          .frame(width: maximum, height: maximum)
          .allowsHitTesting(false)
        
        let new = shape
          .inset(amount: inset)
        
        new
          .fill(Color.green.opacity(0.5))
          .overlay(
            new
              .stroke(lineWidth: 3)
          )
          .overlay(
            Text(
              new.path(in: CGRect.square(maximum))
                .description
            )
            .foregroundStyle(.white)
          )
          .background(Color.gray)
          .frame(width: maximum, height: maximum)
          .allowsHitTesting(false)
          
      }
      .padding()
    }
    
  }
  
  return Demo()
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
        
        Circle()
          .inset(by: insets)
          .border(Color.blue)
          .frame(width: 100, height: 100)
          .overlay {
            Rectangle()
              .inset(by: insets)
              .stroke()
          }
      }
      .padding()
    }
  }
  
  return Demo()
}
