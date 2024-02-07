import SwiftUI

/// A checkered pattern
public struct Check: Shape {
  /// The number of rows in the pattern
  public var rows: Int
  
  /// The number of columns in the pattern
  public var columns: Int
  
  /// Constructs a new check pattern
  /// - Parameters:
  ///   - rows: The number of rows
  ///   - columns: The number of columns
  public init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
  }
  
  public func path(in rect: CGRect) -> Path {
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

#Preview("Check") {
  struct CheckExample: View {
    var body: some View {
      VStack {
        VStack(spacing: 20) {
          Text("Checkerboard")
            .bold()
          
          Check(rows: 8, columns: 8)
            .background { Color.red }
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
  
  return CheckExample()
}
