//
//  winningLineShape.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-08-23.
//

import SwiftUI

/**
- Todo:
    - This should really be a `Shape`, that way the `stroke` modifier could be applied externally
    - game.winner should be passed as a boolean value
    - add line struct instead of using type alias
 */
struct lineAnimation: Shape {
    
    typealias StraightLine = (start: CGPoint, end: CGPoint)
    @State var progress: CGFloat = 1
    
    var startCell: CGPoint
    var endCell: CGPoint
    var gridSize: Int
    
    func path(in rect: CGRect) -> Path {
        let gridVector = CGVector(dx: endCell.x - startCell.x, dy: endCell.y - startCell.y)
        let minDimension = min(rect.width, rect.height)
        let cellSize: CGFloat = minDimension / CGFloat(gridSize)
        let start = CGPoint(
            x: (cellSize * CGFloat(startCell.x)) + (cellSize / 2),
            y: cellSize / 2 + cellSize * CGFloat(startCell.y)
        )
        let end = CGPoint(
            x: start.x + gridVector.dx * cellSize,
            y: start.y + gridVector.dy * cellSize
        )
        var line = (start: start, end: end)
        line = extend(line, by: cellSize / 2)
        return Path() { path in
            path.move(to: line.start)
            path.addLine(to: line.end)
        }
    }
    
    private func extend(_ line: StraightLine, by amount: CGFloat ) -> StraightLine {
        var extendedStart = line.start
        var extendedEnd = line.end
        let line = CGVector(dx: line.end.x - line.start.x, dy: line.end.y - line.start.y)
        
        if line.dx > 0 {
            extendedStart.x -= amount
            extendedEnd.x += amount
        } else if line.dx < 0 {
            extendedStart.x += amount
            extendedEnd.x -= amount
        }
        if line.dy > 0 {
            extendedStart.y -= amount
            extendedEnd.y += amount
        } else if line.dy < 0 {
            extendedStart.y += amount
            extendedEnd.y -= amount
        }
        return (start: extendedStart, end: extendedEnd)
    }
}
