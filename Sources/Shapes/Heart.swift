//
//  Heart.swift
//  
//
//  Created by nutterfi on 5/8/21.
//

import SwiftUI

public struct Heart: NFiShape {
  // normalized
  var origin: CGPoint { CGPoint(x: 0.5, y: 0.2) }
  var bottom: CGPoint { CGPoint(x: 0.5, y: 1) }
  var controlLeft1: CGPoint { CGPoint(x: 0.2, y: -0.35) }
  var controlLeft2: CGPoint { CGPoint(x: -0.4, y: 0.45) }
  var controlRight1: CGPoint { CGPoint(x: 0.8, y: -0.35) }
  var controlRight2: CGPoint { CGPoint(x: 1.4, y: 0.45) }
  
  public var inset: CGFloat = .zero

  public init() {}
  
  public func path(in rect: CGRect) -> Path {
    
    let aRect = rect.insetBy(dx: inset, dy: inset)
    
    func scaledPoint(_ point: CGPoint) -> CGPoint {
      CGPoint(x: aRect.minX + point.x * aRect.width, y: aRect.minY + point.y * aRect.height)
    }
    
    return Path { path in
      path.move(to: scaledPoint(origin))
      path.addCurve(to: scaledPoint(bottom), control1: scaledPoint(controlLeft1), control2: scaledPoint(controlLeft2))
      path.addCurve(to: scaledPoint(origin), control1: scaledPoint(controlRight2), control2: scaledPoint(controlRight1))
      path.closeSubpath()
    }
  }
    
}

struct Heart_Previews: PreviewProvider {
    static var previews: some View {
      VStack {
        ZStack {
          Heart()
            .stroke(lineWidth: 10)
            .scaledToFit()
          Heart()
            .inset(by: 80)
            .stroke(lineWidth: 2)
            .scaledToFit()
        }
        .border(Color.black)
        
        Divider()
        
        Image(systemName: "heart")
          .resizable()
          .scaledToFit()
      }
      .padding()
      
    }
}
