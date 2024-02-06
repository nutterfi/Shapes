import SwiftUI

/// A general shape for drawing a single line with user defined start and end points. It can be drawn within or outside the bounds
public struct Line: Shape {
 
  /// The start point of the line relative to the frame
  public var start: UnitPoint
  
  /// The end point of the line relative to the frame
  public var end: UnitPoint
  
  /// Whether to allow the line to be drawn outside of its bounds. When this is true, the start and end points are clamped to the edges of the frame
  public var boundToFrame: Bool = true
  
  public init(start: UnitPoint, end: UnitPoint, boundToFrame: Bool = true) {
    self.start = start
    self.end = end
    self.boundToFrame = boundToFrame
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: rect.projectedPoint(start, boundToFrame: boundToFrame))
      path.addLine(to: rect.projectedPoint(end, boundToFrame: boundToFrame))
    }
  }
  
}


public extension Line {
  /// A horizontal line that is drawn at the midY level
  static var horizontal: Line {
    Line(start: .leading, end: .trailing)
  }
  
  /// A vertical line that is drawn at the midX level
  static var vertical: Line {
    Line(start: .top, end: .bottom)
  }
}

struct Line_Previews: PreviewProvider {
  
  /// Showcases several different `Line` configurations
  struct LineGallery: View {
    var body: some View {
      VStack {
        Text("Line Examples")
          .font(.headline)
        
        HStack {
          Group {
            Line.horizontal
              .stroke(Color.red)
            
            Line(
              start: UnitPoint(x: -0.5, y: 0),
              end: .bottomTrailing
            )
            .stroke()
            
            Line.vertical
              .stroke()
          }
          .frame(height: 64)
          .border(Color.red)
        }
        .padding()
      }
    }
  }
  
  static var previews: some View {
    LineGallery()
  }
}
