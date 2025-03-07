import SwiftUI

/// A shape with an alignment applied to it. Alignments are applied for the standard HorizontalAlignment and VerticalAlignment definitions.
public struct AlignmentShape<Content: Shape>: Shape {
  
  /// the target shape
  public var shape: Content
  
  /// the alignment
  public var alignment: Alignment
  
  /// Create a new aligned shape.
  public init(shape: Content, alignment: Alignment = .center) {
    self.shape = shape
    self.alignment = alignment
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let shapePath = shape.path(in: rect)
      path.addPath(shapePath)
      
      let bounding = path.cgPath.boundingBoxOfPath
      
      switch alignment {
      case .topLeading:
        path = path
          .offsetBy(dx: rect.minX - bounding.minX, dy: rect.minY - bounding.minY)
      case .topTrailing:
        path = path
          .offsetBy(dx: rect.maxX - bounding.maxX, dy: rect.minY - bounding.minY)
      case .bottomTrailing:
        path = path
          .offsetBy(dx: rect.maxX - bounding.maxX, dy: rect.maxY - bounding.maxY)
      case .bottomLeading:
        path = path
          .offsetBy(dx: rect.minX - bounding.minX, dy: rect.maxY - bounding.maxY)
      case .leading:
        path = path
          .offsetBy(dx: rect.minX - bounding.minX, dy: rect.midY - bounding.midY)
      case .trailing:
        path = path
          .offsetBy(dx: rect.maxX - bounding.maxX, dy: rect.midY - bounding.midY)
      case .top:
        path = path
          .offsetBy(dx: rect.midX - bounding.midX, dy: rect.minY - bounding.minY)
      case .bottom:
        path = path
          .offsetBy(dx: rect.midX - bounding.midX, dy: rect.maxY - bounding.maxY)
      case .center:
        path = path
          .offsetBy(
            dx: rect.midX - bounding.midX,
            dy: rect.midY - bounding.midY
          )
      default:
        break
      }
    }
  }
}

public extension Shape {
  /// aligns this shape using the specified alignment
  func align(with alignment: Alignment = .center) -> AlignmentShape<Self> {
    AlignmentShape(shape: self, alignment: alignment)
  }
}

#Preview {
  struct Demo: View {
    @State private var alignment: Alignment = .center
    var body: some View {
      
      controls
      
      Salinon()
        .align(with: alignment)
        .stroke()
        .border(Color.green)
        .frame(maxWidth: .infinity)
        .frame(height: 100)
        .border(Color.red)
        .padding()
    }
    
    @ViewBuilder
    var controls: some View {
      VStack {
        HStack {
          Button("TL") {
            alignment = .topLeading
          }
          Button("Top") {
            alignment = .top
          }
          Button("TT") {
            alignment = .topTrailing
          }
        }
        HStack {
          Button("Leading") {
            alignment = .leading
          }
          Button("Center") {
            alignment = .center
          }
          Button("Trailing") {
            alignment = .trailing
          }
        }
        HStack {
          Button("BL") {
            alignment = .bottomLeading
          }
          Button("Bottom") {
            alignment = .bottom
          }
          Button("BT") {
            alignment = .bottomTrailing
          }
        }
      }
    }
  }
  
  return Demo()
}
