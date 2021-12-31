//
//  DataPath.swift
//  
//
//  Created by nutterfi on 12/30/21.
//

import SwiftUI

/// draws a scaled path of the data
public struct DataPath: NFiShape {
  public var inset: CGFloat = .zero
  public var data: [CGFloat]

  public func path(in rect: CGRect) -> Path {
    Path { path in
      let insetRect = rect.insetBy(dx: inset, dy: inset)
      let largest = data.max()!
      let smallest = data.min()!
      let factor = max(abs(smallest), largest)

      let scaledData = data.map { $0 / factor }
      
      let dx: CGFloat = insetRect.width / CGFloat(scaledData.count)
      
      for (index, point) in scaledData.enumerated() {
        let x = insetRect.minX + dx * CGFloat(index)
        let y = insetRect.midY + 0.5 * (insetRect.minY - point * insetRect.height)
        
        if index == 0 {
          path.move(to: CGPoint(x: x, y: y))
        }

        path.addLine(to: CGPoint(x: x, y: y))
      }
    }
  }
 
}

extension DataPath {
  static var sample: DataPath {
    DataPath(data: Math.dampedOscillator(points: 800, sampleRate: 500,
                              phase: CGFloat.pi,
                              dampingFactor: 0.0069))
  }
}

struct DataPath_Previews: PreviewProvider {
    static var previews: some View {
      DataPath.sample
      .stroke(Color.purple, lineWidth: 5)
      .frame(width: 400, height: 100)
      .border(Color.purple)
    }
}
