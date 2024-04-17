//
//  AnimatablePoints.swift
//
//
//  Created by nutterfi on 3/5/24.
//

import SwiftUI

struct AnimatableUnitPoints: VectorArithmetic {
  
  var points: [UnitPoint]
  
  static func - (lhs: AnimatableUnitPoints, rhs: AnimatableUnitPoints) -> AnimatableUnitPoints {
    AnimatableUnitPoints(points:lhs.points - rhs.points)
  }
  
  static func + (lhs: AnimatableUnitPoints, rhs: AnimatableUnitPoints) -> AnimatableUnitPoints {
    AnimatableUnitPoints(points:lhs.points + rhs.points)
  }
  
  mutating func scale(by rhs: Double) {
    points = points.map {UnitPoint(x: $0.x * rhs, y: $0.y * rhs)}
  }
  
  var magnitudeSquared: Double {
    points.map { $0.magnitudeSquared }.reduce(0, +)
  }
  
  static var zero: AnimatableUnitPoints {
    AnimatableUnitPoints(points: [])
  }
  
}

extension Array<UnitPoint>: AdditiveArithmetic where UnitPoint: AdditiveArithmetic {
  public static func - (lhs: Array<UnitPoint>, rhs: Array<UnitPoint>) -> Array<UnitPoint> {
    let length: Int = Swift.min(lhs.count, rhs.count)
    
    var difference = Array<UnitPoint>()
    for n in 0..<length {
      difference.append(lhs[n] - rhs[n])
    }
    
    return difference
  }
  
  public static var zero: Array<UnitPoint> {
    return []
  }
  
  
  public static func + (lhs: Array<UnitPoint>, rhs: Array<UnitPoint>) -> Array<UnitPoint> {
    let length: Int = Swift.min(lhs.count, rhs.count)
    
    var sum = Array<UnitPoint>()
    for n in 0..<length {
      sum.append(lhs[n] + rhs[n])
    }
    
    return sum
  }

}

extension Array<UnitPoint>: VectorArithmetic where UnitPoint: VectorArithmetic {
  
  public mutating func scale(by rhs: Double) {
    self = self.map { UnitPoint(x: $0.x * rhs, y: $0.y * rhs) }
  }
  
  public var magnitudeSquared: Double {
    let array: [Double] = self.map { $0.x * $0.x + $0.y * $0.y }
    return array.reduce(0, +)
  }
  
}


extension UnitPoint: VectorArithmetic {
  public static func - (lhs: UnitPoint, rhs: UnitPoint) -> UnitPoint {
    UnitPoint(x: lhs.x - rhs.x, y: lhs.y - rhs.y)
  }
  
  public mutating func scale(by rhs: Double) {
    x *= rhs
    y *= rhs
  }
  
  public var magnitudeSquared: Double {
    x * x + y * y
  }
  
  public static func + (lhs: UnitPoint, rhs: UnitPoint) -> UnitPoint {
    UnitPoint(x: lhs.x + rhs.x, y: lhs.y + rhs.y)
  }
  
}

struct AnimatablePoints: Shape {
  var values: AnimatableUnitPoints
  
  func path(in rect: CGRect) -> Path {
    
    Path { path in
      guard !values.points.isEmpty else { return }
      
      let cgPoints = values.points.map {(rect.projectedPoint($0))}
      
      path.addLines(cgPoints)
    }
    
  }
  
  typealias AnimatableData = AnimatableUnitPoints
  
  var animatableData: AnimatablePoints.AnimatableData {
    
    get {
      values
    }
    
    set {
      values = newValue
    }
  }
}

#Preview("MyDemo") {
  struct Demo: View {
    static let numberOfPoints = 50
    @State private var points: [UnitPoint] = Demo.randomPoints(count: numberOfPoints)
    
    
    var body: some View {
      VStack {
        AnimatablePoints(values: AnimatableUnitPoints(points: points))
          .stroke()
          .foregroundStyle(.purple)
      }
      .contentShape(Rectangle())
      .onTapGesture {
        withAnimation {
          points = Demo.randomPoints(count: Demo.numberOfPoints)
        }
      }
      .padding()
    }
    
    static func randomPoints(count: Int) -> [UnitPoint] {
      var points = Array<UnitPoint>()
      for _ in 0..<count {
        let x = CGFloat.random(in: 0...1)
        let y = CGFloat.random(in: 0...1)
        points.append(UnitPoint(x: x, y: y))
      }
      return points
    }
  }
  
  return Demo()
}
