import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct SpongeFilter<S: Shape, T: Shape>: Shape {
  /// original Shape
  public var base: S
  /// number of sponge "holes"
  public var amount: Int
  /// size of the sponge holes
  public var size: CGFloat
  /// shape of the sponge hole
  public var stencil: T
  
  public init(base: S, amount: Int = 100, size: CGFloat = 1.0, stencil: T) {
    self.base = base
    self.amount = amount
    self.size = size
    self.stencil = stencil
  }
  
  public func randomPositions(number: Int = 100) -> [CGPoint] {
    var positions = [CGPoint]()
    var g = SeededRandomNumberGenerator()
    for _ in 0..<number {
      positions.append(g.randomPoint())
    }
    return positions
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      
      var sponge = Path()
      randomPositions(number: amount).forEach { position in
        let width = position.x * rect.width
        let height = position.y * rect.height
        sponge.addPath(
          stencil.path(
            in: CGRect(
              origin: CGPoint(x: rect.minX + width - size / 2, y: rect.minY + height - size / 2),
              size: CGSize(width: size, height: size)
            )
          )
        )
      }
      
      let cgSponge = sponge.cgPath
      
      let cgBase = base.path(in: rect).cgPath
      
      let difference = cgBase.subtracting(cgSponge)
      
      path.addPath(Path(difference))
    }
  }
}
