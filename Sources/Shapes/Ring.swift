import SwiftUI

/// A circular line that supports styling via StrokeStyle
public struct Ring: Shape {
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used to inset properly
  public var style: StrokeStyle = StrokeStyle()

  /// How many times to repeat the pattern. A nonzero value normalizes the dash patterns to the size of the Ring
  public var repeatCount: Double = .zero
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let theStyle = appliedStyle(in: rect)
      let circlePath = Circle()
        .inset(by: theStyle.lineWidth * 0.5)
        .path(in: rect)
        .strokedPath(theStyle)
      path.addPath(circlePath)
    }
  }
  
  /// Computes the required StrokeStyle to apply to the Path
  func appliedStyle(in rect: CGRect) -> StrokeStyle {
    // input validation
    let count = abs(repeatCount)

    var dash = style.dash
    var dashPhase = style.dashPhase
    
    let outerRadius = min(rect.width, rect.height) * 0.5
    
    let midRadius = outerRadius - (style.lineWidth * 0.5)
    
    let circumference = 2 * .pi * midRadius
        
    if count > 0 {
      // normalized dash pattern
      let sum = dash.reduce(0, +)
      dash = dash.map {$0 * circumference / (sum * count)}
      dashPhase = dashPhase * circumference / (sum * count)
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

/// Showcases Ring and compares it to a Circle equivalent
struct RingExample: View {
  /// The dash pattern applied to each style
  let dash: [CGFloat] = [14, 2, 5, 8]
  
  let size: Double = 128

  var body: some View {
    VStack(spacing: 30) {
      
      Text("Ring Example")
        .font(.headline)
      
      Text("dash: \(String(describing: dash))")
        .font(.subheadline)
      
      HStack(spacing: 20) {
        VStack {
          Text("Circle")
            .font(.caption)
          
          Circle()
            .stroke(style: StrokeStyle(lineWidth: 12, dash: dash))
            .frame(width: size, height: size)
            .border(Color.red.opacity(0.2))
        }
        
        VStack {
          Text("Ring")
            .font(.caption)
          
          Ring(style: StrokeStyle(lineWidth: 12, dash: dash))
            .frame(width: size, height: size)
            .border(Color.red.opacity(0.2))
        }
        
      }
      
      // Show the effect of an increasing repeat count
      ScrollView {
        ForEach(1..<20, id: \.self) { count in
          Text("Ring repeat count: \(count)")
            .font(.caption)
          
          Ring(style: StrokeStyle(lineWidth: 50, dash: dash), repeatCount: Double(count))
            .fill(LinearGradient(colors: [.green, .yellow], startPoint: .leading, endPoint: .trailing))
            .frame(width: size, height: size)
            .border(Color.red.opacity(0.2))
        }
      }
    }
    .padding(.vertical, 20)
  }
}

#Preview {
  RingExample()
}

