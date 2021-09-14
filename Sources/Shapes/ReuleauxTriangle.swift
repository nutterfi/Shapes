//
//  SwiftUIView.swift
//  SwiftUIView
//
//  Created by nutterfi on 9/6/21.
//

import SwiftUI

struct ReuleauxTriangle: Shape {
  func path(in rect: CGRect) -> Path {
    ReuleauxPolygon(sides: 3).path(in: rect)
  }
  
}

struct ReuleauxTriangle_Previews: PreviewProvider {
  static var previews: some View {
    ZStack {
      ReuleauxTriangle()
        .stroke()
        .foregroundColor(.yellow)
    }
    .frame(width: 256, height: 256)
  }
}
