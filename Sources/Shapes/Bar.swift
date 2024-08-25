import SwiftUI

/// A horizontal line that fills the space and supports styling via StrokeStyle
public struct Bar: Shape {
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used as a scaling factor
  public var style: StrokeStyle

  /// How many times to repeat the pattern. A nonzero value normalizes the dash patterns to the size of the Bar
  public var repeatCount: Double
  
  public init(style: StrokeStyle = .init(), repeatCount: Double = .zero) {
    self.style = style
    self.repeatCount = repeatCount
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let linePath = Line.horizontal.path(in: rect)
      path.addPath(linePath.strokedPath(appliedStyle(in: rect)))
    }
  }
  
  /// Computes the required StrokeStyle to apply to the Path
  func appliedStyle(in rect: CGRect) -> StrokeStyle {
    // input validation
    let count = abs(repeatCount)

    var dash = style.dash
    var dashPhase = style.dashPhase
    
    if count > 0 {
      // normalized dash pattern
      let sum = dash.reduce(0, +)
      dash = dash.map {$0 * rect.width / (sum * count)}
      dashPhase = dashPhase * rect.width / (sum * count)
    }
    
    return StrokeStyle(
      lineWidth: rect.height * style.lineWidth,
      lineCap: style.lineCap,
      lineJoin: style.lineJoin,
      dash: dash,
      dashPhase: dashPhase
    )
  }
  
}

#Preview {
  /// Showcases Bar and compares it to a Line.horizontal equivalent
  struct BarExample: View {
    /// The dash pattern applied to each style
    let dash: [CGFloat] = [14, 2, 8]

    var body: some View {
      VStack(spacing: 30) {
        Text("dash: \(String(describing: dash))")
          .font(.headline)
        
        Text("Line.horizontal")
        
        // A Line requires us to specify a line width that may not always equal the shape's frame
        Line.horizontal
          .stroke(style: StrokeStyle(lineWidth: 12, dash: dash))
          .frame(width: 256, height: 40)
          .border(Color.red)
        
        Text("Bar")
        
        // Bar automatically fills the entire frame
        Bar(style: StrokeStyle(dash: dash))
          .frame(width: 256, height: 40)
          .border(Color.red)
        
        // Show the effect of an increasing repeat count
        ScrollView {
          ForEach(1..<20, id: \.self) { count in
            Text("Bar repeat count: \(count)")
            
            Bar(style: StrokeStyle(dash: dash), repeatCount: Double(count))
              .frame(width: 256, height: 10)
              .border(Color.red)
              .foregroundStyle(LinearGradient(colors: [.green, .yellow], startPoint: .leading, endPoint: .trailing))
          }
        }
      }
      .padding(.vertical, 20)
    }
  }

  return BarExample()
}
