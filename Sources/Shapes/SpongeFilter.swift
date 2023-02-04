import SwiftUI

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct SpongeFilter<S: Shape, T: Shape>: Shape {
  public var base: S
  public var amount: Int
  public var size: CGFloat
  public var stencil: T
  
  public init(base: S, amount: Int = 100, size: CGFloat = 1.0, stencil: T) {
    self.base = base
    self.amount = amount
    self.size = size
    self.stencil = stencil
  }
  
  public static func randomPositions(number: Int = 100) -> [CGPoint] {
    var positions = [CGPoint]()
    var g = SystemRandomNumberGenerator()
    for _ in 0..<number {
      let x = CGFloat.random(in: 0...1, using: &g)
      let y = CGFloat.random(in: 0...1, using: &g)
      positions.append(CGPoint(x: x, y: y))
    }
    return positions
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      
      var sponge = Path()
      Self.randomPositions(number: amount).forEach { position in
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
