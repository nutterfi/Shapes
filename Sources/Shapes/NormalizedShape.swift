//
//  NormalizedShape.swift
//  Shapes
//
//  Created by nutterfi on 12/28/24.
//

import SwiftUI

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
/// A shape that provides a weakly-simple path of its containing shape. See `Path.normalized(eoFill:)`.
public struct NormalizedShape<Content>: Shape where Content: Shape {
  /// The containing shape.
  public var shape: Content
  
  /// Whether to use the even-odd rule for determining which areas to treat as the interior of the paths (if true), or the non-zero rule (if false).
  public var eoFill: Bool
  
  /// Creates a new normalized shape.
  public init(shape: Content, eoFill: Bool = true) {
    self.shape = shape
    self.eoFill = eoFill
  }
  
  public func path(in rect: CGRect) -> Path {
    shape.path(in: rect).normalized(eoFill: eoFill)
  }
}

@available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *)
public extension Shape {
  /// A shape that provides a weakly-simple path of its containing shape. See `Path.normalized(eoFill:)`.
  /// - Parameter eoFill: Whether to use the even-odd rule for determining which areas to treat as the interior of the paths (if true), or the non-zero rule (if false).
  /// - Returns: A new shape with the normalization applied.
  func normalized(eoFill: Bool = true) -> NormalizedShape<Self> {
    NormalizedShape(shape: self, eoFill: eoFill)
  }
}
