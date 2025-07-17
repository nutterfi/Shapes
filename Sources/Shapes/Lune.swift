//
//  Lune.swift
//  Shapes
//
//  Created by nutterfi on 7/16/25.
//

import SwiftUI

/// A crescent-style shape created by subtracting the paths of two circles.
/// TODO: Use primitive arc paths to support < iOS 16.0
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
public struct Lune: Shape {
  /// The size of the second disk, relative to the original disk size
  public var sizeFactor: CGFloat
  /// The distance between the two disk centers, relative to the original disk size
  public var centerDistance: UnitPoint
  
  public init(
    sizeFactor: CGFloat = 1.5,
    centerDistance: UnitPoint = UnitPoint(x: -0.5, y: 0)
  ) {
    self.sizeFactor = sizeFactor
    self.centerDistance = centerDistance
  }
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      let size1 = rect.breadth
      
      let mainRect = CGRect(
        center: rect.midXY,
        size: CGSize(width: size1, height: size1)
      )
      
      let size2 = size1 * sizeFactor
      
      let secondRect = CGRect(
        center: rect.midXY,
        size: CGSize(width: size2, height: size2)
      )
        .offsetBy(
          dx: centerDistance.x * size1,
          dy: centerDistance.y * size1
        )
      
      let path1 = Circle().path(in: mainRect)
      let path2 = Circle().path(in: secondRect)
      
      path = Path(path1.cgPath.subtracting(path2.cgPath))
    }
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
#Preview {
  @Previewable @State var sizeFactor: CGFloat = 1.5
  @Previewable @State var centerDistance: UnitPoint = UnitPoint(x: -0.5, y: 0)
  
  VStack {
    Slider(value: $sizeFactor, in: 0...2)
    Slider(value: $centerDistance.x, in: -1...1)
    Slider(value: $centerDistance.y, in: -1...1)
    
    Lune(sizeFactor: sizeFactor, centerDistance: centerDistance)
  }
  .padding()
  
}
