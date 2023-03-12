import SwiftUI

@available(*, deprecated, message: "Use RoundedCornerRectangle(cornerRadius: , corners: [.topRight, .bottomLeft]) instead. DoubleTeardrop will be removed in a later release")
public struct DoubleTeardrop: NFiShape {
  public var inset: CGFloat = .zero
  
  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    let insetRect = rect.insetBy(dx: inset, dy: inset)
    let dim = min(insetRect.width, insetRect.height)
    
    return RoundedCornerRectangle(cornerRadius: dim * 0.5, corners: [.topRight, .bottomLeft]).path(in: insetRect)
  }
  
}

struct DoubleTeardrop_Previews: PreviewProvider {
    static var previews: some View {
      ZStack {
        DoubleTeardrop()
          .stroke()
      }
      .frame(width: 128, height: 128)
    }
}
