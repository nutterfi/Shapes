//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 6/25/22.
//

import SwiftUI

struct CutCornerDemo: View {
  @State private var animating = false
  @State private var cutLength: CGFloat = 0.5
  var body: some View {
    VStack {
      Slider(value: $cutLength)
      GeometryReader { proxy in
        let dim = min(proxy.size.width, proxy.size.height)
        ZStack {
          CutCornerRectangle(cutLength: animating ? dim * cutLength : 0.5 * dim)
            .frame(width: dim, height: dim)
        }
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
    .onAppear {
      animating = true
    }
  }
}

public struct CutCornerRectangle: NFiShape {
  public var inset: CGFloat = .zero
  public var cutLength: CGFloat = .zero
  
  public init(cutLength: CGFloat = .zero) {
    self.cutLength = abs(cutLength)
  }
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    return Path { path in
      path.move(to: CGPoint(x: insetRect.minX, y: insetRect.minY + cutLength))
      path.addLine(to: CGPoint(x: insetRect.minX + cutLength, y: insetRect.minY))
      path.addLine(to: CGPoint(x: insetRect.maxX - cutLength, y: insetRect.minY))
      path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.minY + cutLength))
      path.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY - cutLength))
      path.addLine(to: CGPoint(x: insetRect.maxX - cutLength, y: insetRect.maxY))
      path.addLine(to: CGPoint(x: insetRect.minX + cutLength, y: insetRect.maxY))
      path.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.maxY - cutLength))
      path.closeSubpath()
    }
  }
  
    
}

struct CutCornerRectangle_Previews: PreviewProvider {
    static var previews: some View {
      CutCornerDemo()
        .frame(width: 256, height: 256)
    }
}
