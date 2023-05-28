import SwiftUI

/// This is a general shape for drawing a single line with user defined start and end points. It can be drawn within the bounds or if desired, extend past its frame
public struct Line: Shape {
  /// The start point of the line that falls within the frame, normalized to width and height of 1
  public var start: CGPoint
  
  /// The end point of the line that falls within the frame, normalized to width and height of 1
  public var end: CGPoint
  
  /// Whether to allow the line to be drawn outside of its bounds
  public var allowPointOutsideOfFrame: Bool = false
  
  public init(from : CGPoint, to : CGPoint, allowPointOutsideOfFrame: Bool = false) {
    self.start = from
    self.end = to
    self.allowPointOutsideOfFrame = allowPointOutsideOfFrame
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      path.move(to: scaledPoint(start, in: rect))
      path.addLine(to: scaledPoint(end, in: rect))
    }
  }
}

extension Line {
  func scaledPoint(_ point: CGPoint, in rect: CGRect) -> CGPoint {
    let x = allowPointOutsideOfFrame ? point.x : max(0, min(1.0, point.x))
    let y = allowPointOutsideOfFrame ? point.y : max(0, min(1.0, point.y))
    
    let scaledX = rect.minX + x * rect.width
    let scaledY = rect.minY + y * rect.height
    return CGPoint(x: scaledX, y: scaledY)
  }
}

public extension Line {
  static var horizontal: Line {
    Line(
      from: .init(x: 0, y: 0.5),
      to: .init(x: 1, y: 0.5)
    )
  }
  
  static var vertical: Line {
    Line(
      from: .init(x: 0.5, y: 0),
      to: .init(x: 0.5, y: 1)
    )
  }
}

struct Line_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        Circle()

        Line.horizontal
          .stroke(style: .init(
            lineWidth: 5,
            dash: [10, 10 ,5]
          ))
          .frame(height: 3) // constrain the height!
//          .border(Color.red)
        
        Line.vertical
          .stroke()
        
        HStack {
          Group {
            Line.horizontal
              .stroke(Color.red, lineWidth: 5)
            
            Line(
              from: .init(x: -0.5, y: 0),
              to: .init(x: 1, y: 1), // WOOT
              allowPointOutsideOfFrame: true
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
