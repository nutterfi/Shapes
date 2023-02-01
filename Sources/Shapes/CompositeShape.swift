import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct CompositeShape<Base, Appendage> : Shape where Base: Shape, Appendage: Shape {
  
  public enum Action {
    case adding
    case subtracting
  }
  
  public var base: Base
  public var appendage: Appendage
  public var action: Action
  
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

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)extension Shape {
  public func adding<appendage: Shape>(_ appendage: appendage) -> CompositeShape<Self, appendage> {
    CompositeShape(base: self, appendage: appendage)
  }
  
  public func subtracting<appendage: Shape>(_ appendage: appendage) -> CompositeShape<Self, appendage> {
    CompositeShape(base: self, appendage: appendage, action: .subtracting)
  }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
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
