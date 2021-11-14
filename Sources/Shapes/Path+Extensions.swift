//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 10/26/21.
//

import SwiftUI

public enum OgeeType {
  case cymaRecta // "Sai-muh"
  case cymaReversa
}

public extension Path {
  mutating func addSCurve(in rect: CGRect, control1: CGPoint, control2: CGPoint, reverse: Bool = false) {
    var path = Path()
    path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
    path.addQuadCurve(to: CGPoint(x: rect.midX, y: rect.midY), control: control1)
    
    path.addQuadCurve(to: CGPoint(x: rect.maxX, y: rect.minY), control: control2)
    if reverse {
      path = path.scale(x: -1, y: 1).path(in: rect)
    }
    self.addPath(path)
  }
  
  mutating func addSCurve(to destination: CGPoint, control1: CGPoint, control2: CGPoint) {
    
    // find the midpoint between our current point and the destination
    
    let currentPoint = self.currentPoint ?? .zero
    
    let midPointX = 0.5 * (destination.x - currentPoint.x) + currentPoint.x
    let midPointY = 0.5 * (destination.y - currentPoint.y) + currentPoint.y
    let midPoint = CGPoint(x: midPointX, y: midPointY)
    
    self.addQuadCurve(to: midPoint, control: control1)
    self.addQuadCurve(to: destination, control: control2)
  }
  
  /// controlX: ratio of control point position in x to midpoint of the destination (between 0...1)
  mutating func addOgeeCurve(to destination: CGPoint, controlX: CGFloat, ogeeType: OgeeType = .cymaRecta) {
    
    let currentPoint = self.currentPoint ?? .zero
    
    let midPointX = 0.5 * (destination.x - currentPoint.x) + currentPoint.x
    let midPointY = 0.5 * (destination.y - currentPoint.y) + currentPoint.y
    let midPoint = CGPoint(x: midPointX, y: midPointY)
        
    let dxControl = max(0, min(controlX, 1.0))
    
    let actualControlX = ogeeType == .cymaRecta ? dxControl : 1 - dxControl

    let qtrPointX = actualControlX * (midPoint.x - currentPoint.x) + currentPoint.x // OK
    let qtrPointY = ogeeType == .cymaRecta ? currentPoint.y : midPointY
    
    let threeQtrPointX = destination.x - actualControlX * (destination.x - midPoint.x)
    let threeQtrPointY = ogeeType == .cymaReversa ? midPointY : destination.y
    
    let qtrPoint = CGPoint(x: qtrPointX, y: qtrPointY)
    let threeQtrPoint = CGPoint(x: threeQtrPointX, y: threeQtrPointY)
    
    self.addQuadCurve(to: midPoint, control: qtrPoint)
    self.addQuadCurve(to: destination, control: threeQtrPoint)
  }
}

struct SCurve_Previews: PreviewProvider {
  static var previews: some View {
    Path { path in
      path.move(to: CGPoint(x: 0, y: 0))
      path.addLine(to: CGPoint(x: 128, y: 0))
      path.addArc(center: CGPoint(x: 128, y: 128), radius: 128, startAngle: .radians(-.pi / 2), endAngle: .radians(.pi / 2), clockwise: false)
      path.addOgeeCurve(to: CGPoint(x: 0, y: 0), controlX: 0.5, ogeeType: .cymaReversa)
    }
    .stroke(lineWidth: 2)
    .frame(width: 256, height: 256)
    .previewLayout(.sizeThatFits)
    .border(Color.purple)
  }
}
