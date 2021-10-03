//
//  SwiftUIView.swift
//  
//
//  Created by nutterfi on 10/2/21.
//

import SwiftUI

/// Generates a spirolateral given number of turns, turning angle, and repetitions
/// TODO:
///  Compute whether it can close
///  Compute how many reps required to close
public struct Spirolateral: Shape {
  /// if a single value in the array, the shape will sequentially increase turns. If multiple values are in the array, the shape will use turn values in the order they are received, where negative values indicate reversals
  public var turns: [Int] = [10]
  /// turning angle in degrees
  public var turningAngle: CGFloat = 60
  /// number of repetitions
  public var repetitions: Int = 5
  /// for single-valued turns, specifies which indexes are to be drawn in reverse
  public var reversedIndexes = [Int]()
  
  public func path(in rect: CGRect) -> Path {
    Path { path in
      var point = CGPoint(x: rect.midX, y: rect.midY)
      path.move(to: point)
      
      var angle: CGFloat = 0
      let deltaAngle: Double = Angle(degrees: 180 - turningAngle).radians
      
      for _ in 0..<repetitions {
        if turns.count == 1 {
          for magnitude in 1...turns[0] {
            angle += reversedIndexes.contains(magnitude) ? -deltaAngle : deltaAngle
            let x = CGFloat(magnitude) * cos(angle)
            let y = CGFloat(magnitude) * sin(angle)
            
            point = CGPoint(x: point.x + x, y: point.y + y)
            path.addLine(to: point)
          }
        } else {
          for turn in turns {
            angle += turn < 0 ? -deltaAngle : deltaAngle
            let x = CGFloat(abs(turn)) * cos(angle)
            let y = CGFloat(abs(turn)) * sin(angle)
            
            point = CGPoint(x: point.x + x, y: point.y + y)
            path.addLine(to: point)
          }
        }
      }
      
      let bounding = path.boundingRect
      
      path = path
        .offsetBy(dx: rect.midX - bounding.midX, dy: rect.midY - bounding.midY)
        .scale(x: rect.width / bounding.width, y: rect.height / bounding.height).path(in: rect)
    }
  }
}

struct Spirolateral_Previews: PreviewProvider {
  static var previews: some View {
    Spirolateral()
      .stroke()
      .previewDevice("iPad Pro (12.9-inch) (5th generation)")
  }
}
