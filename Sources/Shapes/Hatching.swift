import SwiftUI

/// Artistic technique used to create shading effects
/// WIP - looking into what is appropriate for animating
/// FIXME: Cross Hatching is not fully ready
public struct Hatching: Shape {
  
  /// Type of curve to use when drawing Contour Hatching
  public enum Contour: Equatable {
    case quadCurve(CGPoint)
    case curve(CGPoint, CGPoint)
  }
  
  /// The available hatching patterns
  public enum Pattern: Hashable {
    case linear
    case cross
    case contour(Contour)
    
    public func hash(into hasher: inout Hasher) {
      switch self {
      case .linear:
        hasher.combine("linear")
      case .cross:
        hasher.combine("cross")
      case .contour(_):
        hasher.combine("contour")
      }
    }
  }
  
  public var animatableData: Double {
    get {
      spacing
    }
    set {
      spacing = newValue
    }
  }
  
  public var spacing: Double
  public var angle: Angle = .zero
  public var pattern: Pattern = .linear
  /// Whether to steadily increase the width of the lines in the pattern
  public var gradientWidth: Bool = false
  public var lineWidth: CGFloat = 1
  
  private let deltaWidth: CGFloat = 2

  public func path(in rect: CGRect) -> Path {
    Path { path in
      var width: CGFloat = 1
      
      switch pattern {
      case .linear:
        for x in stride(from: rect.minX, to: rect.maxX, by: spacing) {
          let start = CGPoint(x: x, y: rect.minY)
          let end = CGPoint(x: x + cos(angle.radians) * rect.height, y: rect.minY + sin(angle.radians) * rect.height)
          if gradientWidth {
            var newPath = Path()
            newPath.move(to: start)
            newPath.addLine(to: end)
            newPath = newPath.strokedPath(StrokeStyle(lineWidth: width))
            path.addPath(newPath)
            width += deltaWidth
          } else {
            path.move(to: start)
            path.addLine(to: end)
          }
        }
      case .cross:
        for x in stride(from: rect.minX, to: rect.maxX, by: spacing) {
          let start = CGPoint(x: x, y: rect.minY)
          let end = CGPoint(x: x + cos(angle.radians) * rect.height, y: rect.minY + sin(angle.radians) * rect.height)
          if gradientWidth {
            var newPath = Path()
            newPath.move(to: start)
            newPath.addLine(to: end)
            newPath = newPath.strokedPath(StrokeStyle(lineWidth: width))
            path.addPath(newPath)
            width += deltaWidth
          } else {
            path.move(to: start)
            path.addLine(to: end)
          }
        }
        
        for x in stride(from: rect.minX, to: rect.maxX, by: spacing) {
          let start = CGPoint(x: x, y: rect.minY)
          let end = CGPoint(x: x - cos(angle.radians) * rect.height, y: rect.minY + sin(angle.radians) * rect.height)
          if gradientWidth {
            var newPath = Path()
            newPath.move(to: start)
            newPath.addLine(to: end)
            newPath = newPath.strokedPath(StrokeStyle(lineWidth: width))
            path.addPath(newPath)
            width += deltaWidth
          } else {
            path.move(to: start)
            path.addLine(to: end)
          }
        }
      case .contour(let contour):
        for x in stride(from: rect.minX, to: rect.maxX, by: spacing) {
          let start = CGPoint(x: x, y: rect.minY)
          let end = CGPoint(x: x + cos(angle.radians) * rect.height, y: rect.minY + sin(angle.radians) * rect.height)
          
          if gradientWidth {
            var newPath = Path()
            
            newPath.move(to: start)
            switch contour {
            case .curve(let point1, let point2):
              newPath.addCurve(to: end, control1: point1, control2: point2)
            case .quadCurve(let point):
              newPath.addQuadCurve(to: end, control: point)
            }
            newPath = newPath.strokedPath(StrokeStyle(lineWidth: width))
            path.addPath(newPath)
            width += deltaWidth
          } else {
            path.move(to: start)
            switch contour {
            case .curve(let point1, let point2):
              path.addCurve(to: end, control1: point1, control2: point2)
            case .quadCurve(let point):
              path.addQuadCurve(to: end, control: point)
            }
          }
        }
      }
      
      if !gradientWidth {
        path = path.strokedPath(StrokeStyle(lineWidth: lineWidth))
      }
    }
  }
}

class HatchViewModel: ObservableObject {
  
  @Published var pattern: Hatching.Pattern = .linear
  
  @Published var control1X: CGFloat = .zero {
    didSet {
      computePattern()
    }
  }
  
  @Published var control1Y: CGFloat = .zero {
    didSet {
      computePattern()
    }
  }
  
  @Published var control2X: CGFloat = .zero {
    didSet {
      computePattern()
    }
  }
  @Published var control2Y: CGFloat = .zero {
    didSet {
      computePattern()
    }
  }
  
  @Published var lineWidth: CGFloat = 1 {
    didSet {
      computePattern()
    }
  }
  
  enum PatternType {
    case linear
    case cross
    case curve
    case quadCurve
  }
  
  @Published var patternType: PatternType = .linear {
    didSet {
      computePattern()
    }
  }
  
  func computePattern() {
    switch patternType {
      
    case .linear:
      pattern = .linear
    case .cross:
      pattern = .cross
    case .curve:
      pattern = .contour(
        .curve(
          CGPoint(x: control1X, y: control1Y),
          CGPoint(x: control2X, y: control2Y)
        ))
    case .quadCurve:
      pattern =
        .contour(
          .quadCurve(
            CGPoint(x: control1X, y: control1Y)
          )
        )
    }
  }
}

struct HatchDemo: View {
  @StateObject private var viewModel = HatchViewModel()
  
  @State var spacing: Float = 20
  @State var angle: Float = 90
  @State var gradientWidth: Bool = false
  
  @State private var isAnimating = false
  
  var body: some View {
    VStack {
      Picker("", selection: $viewModel.patternType) {
        Text("Linear")
          .tag(HatchViewModel.PatternType.linear)
        Text("Cross")
          .tag(HatchViewModel.PatternType.cross)
        Text("Contour QuadCurve")
          .tag(HatchViewModel.PatternType.quadCurve)
        Text("Contour Curve")
          .tag(HatchViewModel.PatternType.curve)
      }
      
      Toggle(isOn: $gradientWidth) {
        Text("Gradient Width")
      }
      
      HStack {
        Text("Spacing")
        Slider(value: $spacing, in: 10...100)
      }
      
      HStack {
        Text("Angle (Deg)")
        Slider(value: $angle, in: 0...90)
      }
      
      HStack {
        Text("Line Width")
        Slider(value: $viewModel.lineWidth, in: 1...40, step: 1.0)
      }
      
      Group {
        HStack {
          Text("Control1.X")
          Slider(value: $viewModel.control1X, in: 0...90)
        }
        HStack {
          Text("Control1.Y")
          Slider(value: $viewModel.control1Y, in: 0...90)
        }
        
        HStack {
          Text("Control2.X")
          Slider(value: $viewModel.control2X, in: 0...90)
        }
        HStack {
          Text("Control2.Y")
          Slider(value: $viewModel.control2Y, in: 0...90)
        }
      }
      
      Spacer()
      
      Image(systemName: "r.joystick.tilt.down.fill")
        .resizable()
        .scaledToFit()
        .clipShape(
          Hatching(
            spacing: isAnimating ? Double(spacing) : 50,
            angle: .degrees(Double(angle)),
            pattern: viewModel.pattern,
            gradientWidth: gradientWidth,
            lineWidth: viewModel.lineWidth
          )
        )
        .frame(width: 256, height: 256)
        .animation(
          Animation.easeInOut(duration: 5).repeatForever(autoreverses: true),
          value: isAnimating
        )
        .border(Color.red)
        .background(Color.blue.opacity(0.1))
      
      Spacer()
    }
    .task {
      isAnimating = true
    }
  }
}

struct Hatching_Previews: PreviewProvider {
  static var previews: some View {
    HatchDemo()
  }
}
