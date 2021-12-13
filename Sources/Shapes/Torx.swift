//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 12/4/21.
//

import SwiftUI

public struct Torx: NFiShape {
  
  public var inset: CGFloat = .zero
  public var sides: Int
  
  /// the amount to inset the positions of the control points for drawing quad curves (as a percentage of the frame of the shape)
  public var controlPointRatio: CGFloat = 0.5
    
  public init(sides: Int, controlPointRatio: CGFloat = 0.5) {
    self.sides = sides
    self.controlPointRatio = controlPointRatio.clamped(to: 0...2.0)
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      let dim = min(insetRect.height, insetRect.width)
      let polygon = ConvexPolygon(sides: sides)
      let vertices = polygon.vertices(in: insetRect)
      let ratio = controlPointRatio > 0.5 ? 1 - controlPointRatio : controlPointRatio
      let controlPoints = polygon
        .vertices(
          in: insetRect
            .insetBy(
              dx: dim * ratio,
              dy: dim * ratio
            ),
          offset: .radians(
            .pi / Double(sides) + (controlPointRatio > 0.5 ? -.pi : 0)
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
}

struct TorxDemo: View {
  @State private var sides: CGFloat = 3
  @State private var ratio: CGFloat = 0.0
  
  var body: some View {
    VStack {
      Slider(value: $sides, in: 3...100)
      Slider(value: $ratio, in: 0.0...2.0)

      Spacer()
      ZStack {
        Torx(sides: Int(sides), controlPointRatio: 0)
          .fill(Color.green)
        Torx(sides: Int(sides), controlPointRatio: ratio)
          .fill(Color.blue)
      }
      .frame(width: 300, height: 300)
      .border(Color.purple)
      Spacer()
    }
  }
}

struct Torx_Previews: PreviewProvider {
  static var previews: some View {
    TorxDemo()
  }
}
