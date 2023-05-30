import Foundation

struct IndexPath: Hashable {
    let row: Int
    let column: Int

    func hash(into hasher: inout Hasher) {
        hasher.combine(row)
        hasher.combine(column)
    }

    static func == (lhs: IndexPath, rhs: IndexPath) {
        lhs.row == rhs.row && lhs.column == rhs.column
    }
}

func calculateDistanceInMatrix(matrix: [[Int]]) -> [[Int]] {
    var closedPoints = [IndexPath: Int]()
    var openedPoints = [IndexPath: Int]()

    for row in 0..<matrix.count {
        for column in 0..<matrix[row].count {
            if matrix[row][column] == 1 {
                closedPoints[IndexPath(row: row, column: column)] = 0
                continue
            }
            openedPoints[IndexPath(row: row, column: column)] = matrix[row][column]
        }
    }

    while !openedPoints.isEmpty {
        if let firstOpened = openedPoints.first {
            var min: Int = .max
            let basicPoints = closedPoints.filter({ $0.value == 0 })
            for item in basicPoints {
                let distance = abs(item.key.row - firstOpened.key.row) + abs(item.key.column - firstOpened.key.column)
                if distance < min {
                    min = distance
                }
            }
            openedPoints[firstOpened.key] = nil
            closedPoints[firstOpened.key] = min
        }
    }

    let sortedClosedPoints = closedPoints.sorted(by: {
        if $0.key.row < $1.key.row {
            return true
        }
        if $0.key.row == $1.key.row {
            return $0.key.column < $1.key.column
        }
        return false
    })

    var resultMatrix = [[Int]]()

    for point in sortedClosedPoints {
        if point.key.row > resultMatrix.count - 1 {
            resultMatrix.append([])
        }
        resultMatrix[point.key.row].append(point.value)
    }

    return resultMatrix
}

let matrix: [[Int]] = [
    [1, 0, 1],
    [0, 1, 0],
    [0, 0, 0]
]

let resultMatrix = calculateDistanceInMatrix(matrix: matrix)
