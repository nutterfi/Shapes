import SwiftUI

/// An inset circular shape that supports styling via StrokeStyle.
/// This shape is an alternative to using `strokeBorder(style:antialiased:)` on `Circle`.
/// FIXME: The combination of an odd repeatCount and odd dash pattern causes unexpected artifacts that can be seen when modifying the dash phase
public struct Ring: Shape {
  /// pass in a style with lineWidth, dash and dash phase elements
  /// the input line width is used to inset properly
  public var style: StrokeStyle

  /// The number of pattern repeats around the ring. A nonzero value normalizes the dash patterns to the size of the Ring
  public var repeatCount: Double
  
  /// Constructs a new ring shape
  /// - Parameters:
  ///   - style: The `StrokeStyle` to apply to the pattern. Uses the default initializer if not specified.
  ///   - repeatCount: The number of pattern repeats around the ring. Defaults to zero. A nonzero value normalizes the dash patterns to the size of the Ring
  public init(style: StrokeStyle = StrokeStyle(), repeatCount: Double = .zero) {
    self.style = style
    self.repeatCount = repeatCount
  }
  
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
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  public func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle().sizeThatFits(proposal)
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
      dashPhase = dashPhase * circumference
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


#Preview {
  /// Showcases Ring and compares it to a Circle equivalent
  struct RingExample: View {
    /// The dash pattern applied to each style
    let dash: [CGFloat] = [14, 2, 5, 8]
    
    let size: Double = 128

    var body: some View {
      VStack(spacing: 20) {
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
              .border(Color.red.opacity(0.2))
          }
          
          VStack {
            Text("Ring")
              .font(.caption)
            
            Ring(style: StrokeStyle(lineWidth: 12, dash: dash))
              .border(Color.red.opacity(0.2))
          }
          
        }
        
        // Show the effect of an increasing repeat count
        ScrollView {
          LazyVGrid(columns: [GridItem(), GridItem(), GridItem()]) {
            ForEach(1..<20, id: \.self) { count in
              VStack {
                Text("Ring repeat count: \(count)")
                  .font(.caption)
                
                Ring(
                  style: StrokeStyle(lineWidth: 12, dash: dash),
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
  return RingExample()
}
