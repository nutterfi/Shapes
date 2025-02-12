//
//  AnimatablePoints.swift
//
//
//  Created by nutterfi on 3/5/24.
//

import SwiftUI

public struct AnimatableUnitPoints: VectorArithmetic, Sendable {
  
  var points: [VectorPoint]
  
  public static func - (lhs: AnimatableUnitPoints, rhs: AnimatableUnitPoints) -> AnimatableUnitPoints {
    AnimatableUnitPoints(points: lhs.points - rhs.points)
  }
  
  public static func + (lhs: AnimatableUnitPoints, rhs: AnimatableUnitPoints) -> AnimatableUnitPoints {
    AnimatableUnitPoints(points:lhs.points + rhs.points)
  }
  
  mutating public func scale(by rhs: Double) {
    points = points.map { VectorPoint(x: $0.x * rhs, y: $0.y * rhs) }
  }
  
  public var magnitudeSquared: Double {
    points.map { $0.magnitudeSquared }.reduce(0, +)
  }
  
  public static var zero: AnimatableUnitPoints {
    AnimatableUnitPoints(points: [])
  }
  
}

public struct AnimatablePoints: Shape, Animatable {
  
  var values: AnimatableUnitPoints
  
  public func path(in rect: CGRect) -> Path {
    
    Path { path in
      guard !values.points.isEmpty else { return }
      
      let cgPoints = values.points.map {(rect.projectedPoint($0.unitPoint))}
      
      path.addLines(cgPoints)
    }
    
  }
    
  public typealias AnimatableData = AnimatableUnitPoints
  
  public var animatableData: AnimatablePoints.AnimatableData {
    
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
    @State private var points: [VectorPoint] = Demo.randomPoints(count: numberOfPoints)
    
    
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
    
    static func randomPoints(count: Int) -> [VectorPoint] {
      var points = Array<VectorPoint>()
      for _ in 0..<count {
        let x = CGFloat.random(in: 0...1)
        let y = CGFloat.random(in: 0...1)
        points.append(VectorPoint(x: x, y: y))
      }
      return points
    }
  }
  
  return Demo()
}
