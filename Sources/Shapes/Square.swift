//
//  Square.swift
//  Shapes
//
//  Created by nutterfi on 3/6/25.
//

import SwiftUI

/// Renders a square shape centered inside the view
struct Square: Shape {
  func path(in rect: CGRect) -> Path {
    Path(CGRect.square(center: rect.midXY, size: rect.breadth))
  }
  
  @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
  func sizeThatFits(_ proposal: ProposedViewSize) -> CGSize {
    Circle()
      .sizeThatFits(proposal)
  }
  
}

#Preview {
  Square()
    .inset(amount: 50)
    .stroke()
    .frame(height: 200)
    .frame(maxWidth: .infinity)
    .border(Color.red)
}

#Preview {
  HStack(alignment: .top) {
    Circle()
    Square()
    Rectangle()
  }
}
