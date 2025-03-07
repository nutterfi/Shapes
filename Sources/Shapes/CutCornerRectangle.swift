//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 6/25/22.
//

import SwiftUI

/// 45-degree angle cuts on any or all corners of a rectangle
public struct CutCornerRectangle: Shape {
  
  public enum Corner: CaseIterable, Sendable {
    case topLeft, topRight, bottomLeft, bottomRight
  }
  
  // each corner may have a separate cut length
  public var corners: [Corner: CGFloat]
  public var ignoreBoundaries: Bool
    
  public init(corners: [Corner: CGFloat], ignoreBoundaries: Bool = false) {
    self.corners = corners
    self.ignoreBoundaries = ignoreBoundaries
  }
  
  public init(cutLength: CGFloat = .zero, ignoreBoundaries: Bool = false) {
    var corners = [Corner: CGFloat]()
    
    for corner in Corner.allCases {
      corners[corner] = cutLength
    }
    self.corners = corners
    self.ignoreBoundaries = ignoreBoundaries
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      // p1X is always minX
      let p1Y: CGFloat = rect.minY + (corners[.topLeft] ?? 0)
      let p2X: CGFloat = rect.minX + (corners[.topLeft] ?? 0) // p2Y is minY
      
      let p1: CGPoint = CGPoint(x: rect.minX, y: p1Y)
      let p2: CGPoint = CGPoint(x: p2X, y: rect.minY)
      
      let p3X: CGFloat = rect.maxX - (corners[.topRight] ?? 0) // p3Y is minY
      let p4Y: CGFloat = rect.minY + (corners[.topRight] ?? 0)
      
      let p3: CGPoint = CGPoint(x: p3X, y: rect.minY)
      let p4: CGPoint = CGPoint(x: rect.maxX, y: p4Y)
      
      let p5Y: CGFloat = rect.maxY - (corners[.bottomRight] ?? 0) // p5X is maxX
      let p6X: CGFloat = rect.maxX - (corners[.bottomRight] ?? 0)
      
      
      let p5: CGPoint = CGPoint(x: rect.maxX, y: p5Y)
      let p6: CGPoint = CGPoint(x: p6X, y: rect.maxY)
      
      let p7X: CGFloat = rect.minX + (corners[.bottomLeft] ?? 0) // p3Y is minY
      let p8Y: CGFloat = rect.maxY - (corners[.bottomLeft] ?? 0)
      
      let p7: CGPoint = CGPoint(x: p7X, y: rect.maxY)
      let p8: CGPoint = CGPoint(x: rect.minX, y: p8Y)
      
      path.move(to: p1)
      path.addLines([p2,p3,p4,p5,p6,p7,p8, p1])
      path.closeSubpath()
    }
  }
}

struct CutCornerRectangle_Previews: PreviewProvider {
    static var previews: some View {
      
      struct CutCornerDemo: View {
        @State private var cutLengthTL: CGFloat = 0
        @State private var cutLengthTR: CGFloat = 0
        @State private var cutLengthBL: CGFloat = 0
        @State private var cutLengthBR: CGFloat = 0
        
        var body: some View {
          VStack {
            Slider(value: $cutLengthTL, in: 0.0...0.5)
            Slider(value: $cutLengthTR, in: 0.0...0.5)
            Slider(value: $cutLengthBL, in: 0.0...0.5)
            Slider(value: $cutLengthBR, in: 0.0...0.5)
            
            GeometryReader { proxy in
              let dim = min(proxy.size.width, proxy.size.height)
              ZStack {
                VStack {
                  
                  HStack {
                    CutCornerRectangle(cutLength: dim * cutLengthTL)
                    let corners: [CutCornerRectangle.Corner: CGFloat] = [.topLeft: dim * cutLengthTL,
                                                                         .topRight: dim * cutLengthTR,
                                                                         .bottomLeft:  dim * cutLengthBL,
                                                                         .bottomRight: dim * cutLengthBR]
                    CutCornerRectangle(corners: corners)
                  }
                  
                }
              }
              .frame(width: proxy.size.width, height: proxy.size.height)
            }
          }
          .padding()
        }
      }
    
      return CutCornerDemo()
    }
}
