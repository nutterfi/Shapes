//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nutterfi on 9/9/21.
//

import SwiftUI


extension Color {
  
  static var random : Color {
    let r = CGFloat.random(in: 0...1)
    let g = CGFloat.random(in: 0...1)
    let b = CGFloat.random(in: 0...1)
    return .init(red: r, green: g, blue: 1)
  }
      
}
/// 1 column tesselation requires that the triangles are drawn with opposite directions, and their bases/tips are touching
struct TesselationDemo: View {
  @State private var isAnimating: Bool = false
  @State private var rotation3D: CGFloat = 0

  func vertTriangles(count: Int) -> some View {
    VStack(spacing: 0) {
      ForEach(0..<count, id: \.self) { index in
          ConvexPolygon(sides:12)
            .rotation(.degrees(index % 2 == 0 ? 0 : 180))
            .foregroundColor(Color.random)
            .hueRotation(.degrees(isAnimating ? 180 : 0))
            .animation(Animation.easeInOut(duration: 4).repeatForever(), value: isAnimating)
      }
    }
  }
  
    var body: some View {
      
      VStack {
        Slider(value: $rotation3D)
        GeometryReader { proxy in
          let dim = min(proxy.size.width, proxy.size.height)
          ZStack {
            HStack(spacing:0) {
              ForEach(0..<10, id: \.self) { _ in
                vertTriangles(count: 10)
                  .frame(width: dim / 10)
              }
            }
            .rotation3DEffect(.radians(2 * .pi * rotation3D), axis: (x: 1 , y: 1, z: 0))
          }
          .background(Color.gray)
          .frame(width: proxy.size.width, height: proxy.size.height)
          .onAppear {
            isAnimating = true
          }
        }
      }
    }
}

struct TesselationDemo_Previews: PreviewProvider {
    static var previews: some View {
      TesselationDemo()
    }
}
