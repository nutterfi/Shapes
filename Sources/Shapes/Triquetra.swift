//
//  Triquetra.swift
//  
//
//  Created by nutterfi on 10/12/21.
//

import SwiftUI

// WIP - NO math behind this yet
public struct TriquetraView: View {
  public init() {}
  public var body: some View {
    GeometryReader { proxy in
      let dim = min(proxy.size.width, proxy.size.height)
      let offsetY = 0.16
      ZStack {
        ZStack {
          Lens()
            .stroke(Color.purple, lineWidth: 5)
            .offset(x: 0, y: -dim * offsetY)
            .frame(width: dim * 0.75, height: dim * 0.75)
          Lens()
            .stroke(Color.purple, lineWidth: 5)
            .offset(x: 0, y: -dim * offsetY)
            .rotationEffect(.degrees(120))
            .frame(width: dim * 0.75, height: dim * 0.75)
          Lens()
            .stroke(Color.purple, lineWidth: 5)
            .offset(x: 0, y: -dim * offsetY)
            .rotationEffect(.degrees(240))
            .frame(width: dim * 0.75, height: dim * 0.75)
        }
        .offset(x: 0, y: dim * 0.1)
        .frame(width: proxy.size.width, height: proxy.size.height)
      }
    }
  }
}

struct Triquetra_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        TriquetraView()
          .frame(width: 256, height: 256)
          .border(Color.purple)
      }
    }
}
