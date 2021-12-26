//
//  Salinon.swift
//  
//
//  Created by nutterfi on 12/25/21.
//

import SwiftUI

public struct Salinon: NFiShape {
  
  public var inset: CGFloat = .zero
  public var innerDiameterRatio: CGFloat = 0.2
  public var centered: Bool = false
  
  public init(inset: CGFloat = .zero, innerDiameterRatio: CGFloat = 0.2, centered: Bool = false) {
    self.inset = inset
    self.innerDiameterRatio = innerDiameterRatio
    self.centered = centered
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      let dim = min(insetRect.width, insetRect.height)
      let center = CGPoint(x: insetRect.midX, y: insetRect.midY)
      
      // outer semicircle
      path.addArc(center: center, radius: dim * 0.5, startAngle: .radians(.pi), endAngle: .zero, clockwise: false)
      
      // AD and EB
      let outerDiameterRatio = (1.0 - innerDiameterRatio) * 0.5
      
      let pointB = path.currentPoint!

      let EBCenter = CGPoint(x: pointB.x - dim * outerDiameterRatio * 0.5, y: insetRect.midY)
      
      path.addArc(center: EBCenter, radius: dim * outerDiameterRatio * 0.5, startAngle: .zero, endAngle: .radians(.pi), clockwise: true)

      // DE arc
      path.addArc(center: center, radius: dim * innerDiameterRatio * 0.5, startAngle: .zero, endAngle: .radians(.pi / 2 ), clockwise: false)

      _ = path.currentPoint!  // Point 'F'

      path.addArc(center: center, radius: dim * innerDiameterRatio * 0.5, startAngle: .radians(.pi / 2 ), endAngle: .radians(.pi), clockwise: false)
      
      let pointD = path.currentPoint!  // Point 'D'

      let ADCenter = CGPoint(x: pointD.x - dim * outerDiameterRatio * 0.5, y: insetRect.midY)

      path.addArc(center: ADCenter, radius: dim * outerDiameterRatio * 0.5, startAngle: .zero, endAngle: .radians(.pi), clockwise: true)
      
      if centered {
        let bounding = path.boundingRect
        let boundingDim = max(bounding.width, bounding.height)
        
        path = path
          .offsetBy(dx: insetRect.midX - bounding.midX, dy: insetRect.midY - bounding.midY)
          .scale(dim / boundingDim)
          .path(in: insetRect)
      }
    }
  }
}

struct SalinonDemo: View {
  @State private var ratio: CGFloat = 0.2
  @State private var inset: CGFloat = 0
  @State private var centered: Bool = false
  var body: some View {
    VStack {
      Slider(value: $ratio)
      Slider(value: $inset, in: 0.0...0.49, step: 0.01)
      Toggle("Centered", isOn: $centered)
      Spacer()
      Salinon(innerDiameterRatio: ratio, centered: centered)
        .inset(by: inset * 128)
        .stroke(Color.red)
        .frame(width: 256, height: 128)
        .border(Color.purple)
      
      Salinon(innerDiameterRatio: ratio, centered: centered)
        .inset(by: inset * 256)
        .stroke(Color.red)
        .frame(width: 256, height: 256)
        .border(Color.purple)
      
      Salinon(innerDiameterRatio: ratio, centered: centered)
        .inset(by: inset * 128)
        .stroke(Color.red)
        .frame(width: 128, height: 256)
        .border(Color.purple)

      Spacer()
    }
  }
}

struct Salinon_Previews: PreviewProvider {
  static var previews: some View {
    SalinonDemo()
  }
}
