//
//  BorderedRectangle.swift
//  book-swiftui-shapes-examples
//
//  Created by nutterfi on 9/2/23.
//

import SwiftUI

/// An inset rectangular shape that supports styling via StrokeStyle.
/// This shape is an alternative to using `strokeBorder(style:antialiased:)` on `Rectangle`.
public struct BorderedRectangle: Shape {
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used to inset properly
  public var style: StrokeStyle = StrokeStyle()

  /// How many times to repeat the pattern. A nonzero value normalizes the dash patterns to the size of the BorderedRectangle
  public var repeatCount: Double = .zero
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let theStyle = appliedStyle(in: rect)
      let rectanglePath = Rectangle()
        .inset(by: theStyle.lineWidth * 0.5)
        .path(in: rect)
        .strokedPath(theStyle)
      path.addPath(rectanglePath)
    }
  }
  
  @available(iOS 16.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Rectangle().sizeThatFits(proposal)
  }
  
  /// Computes the required StrokeStyle to apply to the Path
  func appliedStyle(in rect: CGRect) -> StrokeStyle {
    // input validation
    let count = abs(repeatCount)

    var dash = style.dash
    var dashPhase = style.dashPhase
    
    let insetRect = rect.insetBy(dx: style.lineWidth * 0.5, dy: style.lineWidth * 0.5)
    
    let length = 2 * (insetRect.width + insetRect.height)
        
    if count > 0 {
      // normalized dash pattern
      let sum = dash.reduce(0, +)
      dash = dash.map {$0 * length / (sum * count)}
      dashPhase = dashPhase * length
    }
    
    return StrokeStyle(
      lineWidth: style.lineWidth,
      lineCap: style.lineCap,
      lineJoin: style.lineJoin,
      dash: dash,
      dashPhase: dashPhase
    )
  }
  
}

/// Showcases BorderedRectangle and compares it to a Circle equivalent
struct BorderedRectangleExample: View {
  @State private var phase: CGFloat = .zero
  /// The dash pattern applied to each style
  let dash: [CGFloat] = [1, 1]
  
  let size: Double = 128

  var body: some View {
    VStack(spacing: 20) {
      Text("BorderedRectangle Example")
        .font(.headline)
      Slider(value: $phase, in: 0...1)
      Text("dash: \(String(describing: dash))")
        .font(.subheadline)
      
      HStack(spacing: 20) {
        VStack {
          Text("Rectangle")
            .font(.caption)
          
          Rectangle()
            .stroke(style: StrokeStyle(
              lineWidth: 1, lineCap: .round,
              lineJoin: .round,
              dash: dash, 
              dashPhase: phase)
            )
            .border(Color.red.opacity(0.2))
            .aspectRatio(0.75, contentMode: .fit)
        }
        
        VStack {
          Text("BorderedRectangle")
            .font(.caption)
          
          BorderedRectangle(style: StrokeStyle(
            lineWidth: 1,
            lineCap: .square,
            lineJoin: .round,
            dash: dash,
            dashPhase: phase)
          )
            .border(Color.red.opacity(0.2))
            .aspectRatio(0.75, contentMode: .fit)
        }
        
      }
      
      
      // Show the effect of an increasing repeat count
      ScrollView {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
          ForEach(1..<19, id: \.self) { count in
            VStack {
              Text("BorderedRectangle repeat count: \(count)")
                .font(.caption)
              
              BorderedRectangle(
                style: StrokeStyle(
                  lineWidth: 12,
                  lineCap: .square,
                  lineJoin: .round,
                  dash: dash,
                  dashPhase: phase),
                repeatCount: Double(count)
              )
                .fill(LinearGradient(colors: [.green, .yellow], startPoint: .leading, endPoint: .trailing))
                .border(Color.red.opacity(0.2))
                .aspectRatio(0.75, contentMode: .fit)
            }
            
          }
          
        }
        
      }
      
    }
    .padding(20)
  }
}

#Preview {
  BorderedRectangleExample()
}
