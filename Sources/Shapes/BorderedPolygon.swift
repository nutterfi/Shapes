//
//  BorderedPolygon.swift
//  book-swiftui-shapes-examples
//
//  Created by nutterfi on 9/2/23.
//

import SwiftUI

/// An inset polygon shape that supports styling via StrokeStyle.
/// This shape is an alternative to using `strokeBorder(style:antialiased:)` on `RegularPolygon`.
public struct BorderedPolygon: Shape {
  public var sides: Int = 3
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used to inset properly
  public var style: StrokeStyle = StrokeStyle()

  /// How many times to repeat the pattern. A nonzero value normalizes the dash patterns to the size of the BorderedPolygon
  public var repeatCount: Double
  
  public init(_ sides: Int, style: StrokeStyle, repeatCount: Double = .zero) {
    self.sides = sides
    self.style = style
    self.repeatCount = repeatCount
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let theStyle = appliedStyle(in: rect)
      let polygonPath = InsettableWrapperShape(shape: RegularPolygon(sides: sides))
        .inset(by: theStyle.lineWidth * 0.5)
        .path(in: rect)
        .strokedPath(theStyle)
      path.addPath(polygonPath)
    }
  }
  
  @available(iOS 16.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
  }
  
  /// Computes the required StrokeStyle to apply to the Path
  func appliedStyle(in rect: CGRect) -> StrokeStyle {
    // input validation
    let count = abs(repeatCount)

    var dash = style.dash
    var dashPhase = style.dashPhase
    
    let insetRect = rect.insetBy(dx: style.lineWidth * 0.5, dy: style.lineWidth * 0.5)
    
    let points = RegularPolygon(sides: sides).points(in: insetRect)
    
    let sideLength = points[0].distance(to: points[1])
    
    let length = sideLength * Double(sides)
        
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

/// Showcases BorderedPolygon and compares it to a Circle equivalent
struct BorderedPolygonExample: View {
  @State private var phase: CGFloat = .zero
  /// The dash pattern applied to each style
  let dash: [CGFloat] = [14, 7, 5, 8]
  @State private var sides: CGFloat = 3
  
  let size: Double = 128

  var body: some View {
    VStack(spacing: 20) {
      Text("BorderedPolygon Example")
        .font(.headline)
      Slider(value: $phase)
      
      Slider(value: $sides, in: 3...103)
      
      Text("dash: \(String(describing: dash))")
        .font(.subheadline)
      
      HStack(spacing: 20) {
        VStack {
          Text("RegularPolygon")
            .font(.caption)
          
          RegularPolygon(sides: Int(sides))
            .stroke(style: StrokeStyle(lineWidth: 1, lineCap: .round, dash: dash, dashPhase: phase))
            .border(Color.red.opacity(0.2))
        }
        
        VStack {
          Text("BorderedPolygon")
            .font(.caption)
          
          BorderedPolygon(
            Int(sides),
            style: StrokeStyle(
            lineWidth: 1,
            lineCap: .square,
            dash: dash,
            dashPhase: phase)
          )
            .border(Color.red.opacity(0.2))
        }
        
      }
      
      
      // Show the effect of an increasing repeat count
      ScrollView {
        LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
          ForEach(1..<19, id: \.self) { count in
            VStack {
              Text("BorderedPolygon repeat count: \(count)")
                .font(.caption)
              
              BorderedPolygon(
                Int(sides),
                style: StrokeStyle(
                  
                  lineWidth: 12,
                  lineCap: .round,
                  lineJoin: .miter,
                  dash: dash,
                  dashPhase: phase),
                repeatCount: Double(count)
              )
                .fill(LinearGradient(colors: [.green, .yellow], startPoint: .leading, endPoint: .trailing))
                .border(Color.red.opacity(0.2))
            }
            
          }
          
        }
        
      }
      
    }
    .padding(20)
  }
}

#Preview {
  BorderedPolygonExample()
}
