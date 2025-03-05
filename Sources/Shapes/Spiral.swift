//
//  Spiral.swift
//  Shapes
//
//  Created by nutterfi on 2/25/25.
//

import SwiftUI

extension WIP {
  
  /// An Archimedean spiral shape.
  /// WIP. The shape attempts to autoscale to fit the bounds but it is not ideal for c values that are not 1
  public struct Spiral: Shape {
    
    /// Number of spiral turns. Can be partial.
    public var turns: CGFloat
    
    /// Initial distance from origin, as a ratio of the frame used to draw the shape
    public var offset: CGFloat
    
    /// responsible for creating the spiral shape
    /// c = 1, standard Archimedes spiral
    /// c = 2: Fermat's spiral
    /// c = -1, hyperbolic spiral
    /// c = -2, lituus spiral
    public var growthRate: CGFloat
    
    /// Creates a new spiral.
    public init(
      turns: CGFloat = 1,
      offset: CGFloat = 0,
      growthRate: CGFloat = 1
    ) {
      self.turns = turns
      self.offset = offset
      self.growthRate = growthRate
    }
    
    public func path(in rect: CGRect) -> Path {
      Path { path in
        let maxRadius = rect.breadth / 2
        
        /**
         General Spiral equation:
         
         r = a + b⋅θ^(1/c)
         
         a: offset from the center
         b: spacing between turns (real number)
         c: growth rate (nonzero)
         
         Converting to cartesian coordinates
         
         x = r(θ) * cos(θ)
         = a + b⋅θ^(1/c) * cos(θ)
         
         y = r(θ) * sin(θ)
         = a + b⋅θ^(1/c) * sin(θ)
         
         Calculate the control points for drawing the path with quad curves
         First calculate the derivate at a point using product rule
         dx/dθ = d/dθ(r cos(θ)) = dr/dθ cos(θ) - r sin(θ)
         
         dr/dθ = (b/c)⋅θ^[(1-c)/c]
         
         so dx/dθ = -r sin(θ) + (b/c)⋅θ^[(1-c)/c]⋅cos(θ)
         
         dy/dθ  = d/dθ(r sin(θ)) = dr/dθ sin(θ) + r cos(θ)
         = r cos(θ) + (b/c)⋅θ^[(1-c)/c]⋅sin(θ)
         */
        
        let a = offset * rect.breadth
        /// b is now relative to the frame, so that we can always draw the number of turns inside the bounds
        /// This only works well for Archimedes spirals
        let b: CGFloat = maxRadius / (2 * .pi * turns)
        
        let c: CGFloat = growthRate
        
        let maxTheta = 2 * .pi * turns
        let dTheta: CGFloat = 2 * .pi / 12
        var theta = Array(stride(from: 0, through: maxTheta, by: dTheta))
        if let last = theta.last, last != maxTheta {
          theta.append(maxTheta)
        }
        
        let center = rect.midXY
        
        // calculate the positions and their derivatives
        let values: [(CGPoint, CGFloat)] = theta.map {
          let r = a + b * pow($0, 1 / c)
          let x = r * cos($0)
          let y = r * sin($0)
          
          let dr = (b / c) * pow($0, (1 - c) / c)
          let dx = dr * cos($0) - r * sin($0)
          let dy = dr * sin($0) + r * cos($0)
          
          let m = dy / dx
          
          return (CGPoint(x: center.x + x, y: center.y + y), m)
        } .filter { $0.0.x.isFinite && $0.0.y.isFinite }
        
        
        for (index, value) in values.enumerated() {
          if index == 0 {
            path.move(to: value.0)
          } else {
            let p1 = values[index-1].0
            let m1 = values[index-1].1
            
            let b1 = p1.y - m1 * p1.x
            
            let p2 = value.0
            let m2 = value.1
            
            let b2 = p2.y - m2 * p2.x
            
            if m1 == m2 {
              path.addQuadCurve(to: value.0, control: value.0)
            } else {
              let x = (b2 - b1) / (m1 - m2)
              let y = m1 * x + b1
              let point = CGPoint(x: x, y: y)
              path.addQuadCurve(to: value.0, control: point)
            }
          }
        }
      }
    }
  }
  
}


fileprivate extension WIP.Spiral {
  enum SpiralType: CGFloat, Hashable {
    case archimedes = 1.0
    case lituus = -2.0
    case hyperbolic = -1.0
    case fermat = 2.0
  }
}

@available(macOS 14.0, iOS 17.0, *)
#Preview {
  @Previewable @State var turns: CGFloat = 1
  @Previewable @State var offset: CGFloat = 0
  @Previewable @State var growth: WIP.Spiral.SpiralType = .archimedes
  
  VStack {
    Text("Turns: " + turns.formatted()).monospacedDigit()
    Slider(value: $turns, in: 0.0...10, step: 1/24)
    
    Text("Offset: " + offset.formatted()).monospacedDigit()
    Slider(value: $offset, in: 0.0...0.1, step: 0.01)
    
    Picker(selection: $growth) {
      Text("Lituus").tag(WIP.Spiral.SpiralType.lituus)
      Text("Archimedes").tag(WIP.Spiral.SpiralType.archimedes)
      Text("Hyperbolic").tag(WIP.Spiral.SpiralType.hyperbolic)
      Text("Fermat").tag(WIP.Spiral.SpiralType.fermat)
    } label: {
      Text("C")
    }
    .pickerStyle(.segmented)

    
    let shape = WIP.Spiral(turns: turns, offset: offset, growthRate: growth.rawValue)
  
    shape
      .fill(Color.yellow)
      .stroke(Color.black, lineWidth: 5)
      .frame(width: 256, height: 256)
      .border(Color.black)
      .background {
        IsotoxalPolygon(sidePairs: 12, innerRadius: 0)
          .stroke(Color.red.opacity(0.2))
      }
    
    Text(shape.path(in: .square(100)).description)
    
    Spacer()
  }
  .padding()
}

@available(macOS 14.0, iOS 17.0, *)
#Preview {
  @Previewable @State var isAnimating: Bool = false
  
  WIP.Spiral(turns: 5)
    .trim(from: 0, to: isAnimating ? 1 : 0)
    .fill(Color.red)
    .stroke(Color.yellow, lineWidth: 5)
    .contentShape(.rect)
    .animation(.easeInOut(duration: 1), value: isAnimating)
    .frame(width: 256, height: 256)
    .onTapGesture {
      isAnimating.toggle()
    }
  
}
