//
//  NFiShape.swift
//  
//
//  Created by nutterfi on 5/27/23.
//

import SwiftUI

public protocol NFiShape: InsettableShape {
  var inset: CGFloat { get set }
}

public extension NFiShape {
  func inset(by amount: CGFloat) -> some InsettableShape {
    var me = self
    me.inset += amount
    return me
  }
}
