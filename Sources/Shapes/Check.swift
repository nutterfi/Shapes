//
//  Check.swift
//  book-swiftui-shapes-examples
//
//  Created by nutterfi on 10/31/23.
//

import SwiftUI

/// A checkered pattern
struct Check: Shape {
  var rows: Int
  var columns: Int
  
  func path(in rect: CGRect) -> Path {
    Path { path in
      let width = rect.width / CGFloat(columns)
      let height = rect.height / CGFloat(rows)
      let size = CGSize(width: width, height: height)
      
      var rects = [CGRect]()
      
      // paint even rows with even columns
      // paint odd rows with odd columns
      for row in 0..<rows {
        for column in 0..<columns {
          if isEvenRowEvenColumn(row: row, column: column) || isOddRowOddColumn(row: row, column: column) {
            let origin = CGPoint(
              x: rect.minX + CGFloat(column) * width,
              y: rect.minY + CGFloat(row) * height
            )
            let iRect = CGRect(origin: origin, size: size)
            rects.append(iRect)
          }
        }
      }
      
      path.addRects(rects)
    }
  }
  
  func isEvenRowEvenColumn(row: Int, column: Int) -> Bool {
    row.isMultiple(of: 2) && column.isMultiple(of: 2)
  }
  
  func isOddRowOddColumn(row: Int, column: Int) -> Bool {
    !row.isMultiple(of: 2) && !column.isMultiple(of: 2)
  }
}

struct CheckExample: View {
  var body: some View {
    Example(title: "Check Example") {
      VStack(spacing: 20) {
        Text("Checkerboard")
          .bold()
        
        Check(rows: 8, columns: 8)
//          .background { Color.red }
          .frame(width: 256, height: 256)
          .border(Color.black)
        
        Text("Transparency Layer")
          .bold()
        
        Check(rows: 12, columns: 12)
          .foregroundStyle(Color.gray)
          .background { Color.white }
          .overlay {
            Image(systemName: "swift")
              .resizable()
              .scaledToFit()
          }
          .frame(width: 256, height: 256)
          .border(Color.black)
      }
      Spacer()
    }
  }
}

#Preview("Check") {
  CheckExample()
}
