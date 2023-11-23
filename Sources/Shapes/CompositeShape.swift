import SwiftUI

/// A shape constructed by combining two other shapes.
@available(iOS, introduced: 16.0, deprecated: 17.0, message: "Use available shape operations instead")
@available(macOS, introduced: 13.0, deprecated: 14.0, message: "Use available shape operations instead")
@available(tvOS, introduced: 16.0, deprecated: 17.0, message: "Use available shape operations instead")
@available(watchOS, introduced: 9.0, deprecated: 10.0, message: "Use available shape operations instead")
@available(visionOS, deprecated: 1.0, message: "Use available shape operations instead")
public struct CompositeShape<Base, Appendage> : Shape where Base: Shape, Appendage: Shape {
  
  /// The available operations for this composite shape
  public enum Action : Sendable {
    case adding
    case subtracting
  }
  
  /// The original shape
  public var base: Base
  
  /// The shape to be applied to `base`
  public var appendage: Appendage
  
  /// The operation to apply to `appendage`
  public var action: Action
  
  /// Creates a new composite shape.
  public init(
    base: Base,
    appendage: Appendage,
    action: Action = .adding
  ) {
    self.base = base
    self.appendage = appendage
    self.action = action
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      guard !rect.isNull else { return }
      guard !base.path(in: rect).isEmpty, !appendage.path(in: rect).isEmpty else { return }
      
      let cgBase = base.path(in: rect).cgPath
      let cgAppendage = appendage.path(in: rect).cgPath
      switch action {
      case .adding:
        path.addPath(Path(cgBase.union(cgAppendage)))
      case .subtracting:
        path.addPath(Path(cgBase.subtracting(cgAppendage)))
      }
    }
  }
  
}

@available(iOS, introduced: 16.0, deprecated: 17.0, message: "Use available shape operations instead")
@available(macOS, introduced: 13.0, deprecated: 14.0, message: "Use available shape operations instead")
@available(tvOS, introduced: 16.0, deprecated: 17.0, message: "Use available shape operations instead")
@available(watchOS, introduced: 9.0, deprecated: 10.0, message: "Use available shape operations instead")
@available(visionOS, deprecated: 1.0, message: "Use available shape operations instead")
extension Shape {
  public func adding<appendage: Shape>(_ appendage: appendage) -> CompositeShape<Self, appendage> {
    CompositeShape(base: self, appendage: appendage)
  }
  
  public func subtracting<appendage: Shape>(_ appendage: appendage) -> CompositeShape<Self, appendage> {
    CompositeShape(base: self, appendage: appendage, action: .subtracting)
  }
}

@available(iOS, introduced: 16.0, deprecated: 17.0, message: "Use available shape operations instead")
@available(macOS, introduced: 13.0, deprecated: 14.0, message: "Use available shape operations instead")
@available(tvOS, introduced: 16.0, deprecated: 17.0, message: "Use available shape operations instead")
@available(watchOS, introduced: 9.0, deprecated: 10.0, message: "Use available shape operations instead")
@available(visionOS, deprecated: 1.0, message: "Use available shape operations instead")
struct CompositeShape_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      ZStack {
        CompositeShape(
          base: ConvexPolygon(sides: 20),
          appendage: ConvexPolygon(sides: 3)
            .offset(.init(width: 0, height: 70)),
          action: .subtracting
        )
        .adding(StarPolygon(points: 5, density: 2))
        .rotation(.degrees(-90))
        .adding(StarPolygon(points: 7, density: 4))
        .subtracting(Salinon())
        .foregroundColor(.red)
        .frame(width: 128, height: 256)
        
        Reuleaux.triangle
          .subtracting(Circle().scale(0.5))
          .foregroundColor(.orange)
        
      }
      
      Spacer()
    }
  }
}
