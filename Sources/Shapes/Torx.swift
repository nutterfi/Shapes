import SwiftUI

/// Draws a "Torx" shape, which can be described as the appearance of one of those screws that Apple uses to prevent you from repairing your own device.
public struct Torx: NFiShape {
  /// The inset amount, in points
  public var inset: CGFloat = .zero
  
  /// The number of sides of the torx shape.
  public var sides: Int
  
  /// The amount to inset the positions of the control points for drawing quad curves (as a percentage of the shortest edge of the shape's bounds)
  /// The relative positions of the control points used to draw the torx curves.
  public var controlPointInset: CGFloat = 0.5
  
  /// Constructs a new torx shape.
  /// - Parameters:
  ///   - sides: The number of sides of the torx shape.
  ///   - controlPointInset: The relative positions of the control points used to draw the torx curves.
  public init(sides: Int, controlPointInset: CGFloat = 0.5) {
    self.sides = sides
    self.controlPointInset = controlPointInset.clamped(to: 0...2.0)
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      let dim = min(insetRect.height, insetRect.width)
      let polygon = ConvexPolygon(sides: sides)
      let vertices = polygon.vertices(in: insetRect)
      let ratio = controlPointInset > 0.5 ? 1 - controlPointInset : controlPointInset
      let controlPoints = polygon
        .vertices(
          in: insetRect
            .insetBy(
              dx: dim * ratio,
              dy: dim * ratio
            ),
          offset: .radians(
            .pi / Double(sides) + (controlPointInset > 0.5 ? -.pi : 0)
          )
        )
      
      path.move(to: vertices.first!)
      
      for (index, _) in vertices.enumerated() {
        path.addQuadCurve(
          to: vertices[(index + 1) % vertices.count],
          control: controlPoints[index]
        )
      }
      
    }
  }
  
  @available(iOS 16.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
}


struct Torx_Previews: PreviewProvider {

  static var previews: some View {
    struct TorxDemo: View {
      @State private var sides: CGFloat = 8
      @State private var inset: CGFloat = 0.5
      
      var body: some View {
        VStack {
          Text("Sides: \(String(format: "%d", Int(sides)))")
          Slider(value: $sides, in: 2...100, step: 1)
          
          Text("Control Point Inset: \(String(format: "%.2f", inset))")
          Slider(value: $inset, in: 0.0...2.0)

          ZStack {
            Torx(sides: Int(sides), controlPointInset: 0)
              .fill(Color.green)
            
            Torx(sides: Int(sides), controlPointInset: inset)
              .stroke(Color.blue)
          }
          .border(Color.red)
          
          Spacer()
          
        }
        .padding()
      }
    }
    
    return TorxDemo()
  }
}
