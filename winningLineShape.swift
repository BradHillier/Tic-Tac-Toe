//
//  winningLineShape.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-08-23.
//

import SwiftUI

struct winLine: Shape {
    var paths: [CGPoint]
    
    var animatableData: [CGPoint] {
        get { paths }
        set { paths = newValue }
    }
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: paths.first!)
        for point in paths[1...] {
            path.addLine(to: point)
        }
        return path
    }
}

struct lineAnimation: View {
    
    typealias Line = (start: CGPoint, end: CGPoint)
    
    @ObservedObject var game: ImageTicTacToeGame
    let color: Color
   
    @State var progress = CGFloat.zero
    
    var body: some View {
        GeometryReader { geometry in
            if game.winner != nil {
                let (start, end) = getLinePositions(in: geometry)
                winLine(paths: [start, end])
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .onAppear {
                        withAnimation(.easeInOut) { progress = 1.0 }
                    }
            } else {
                /// resets the animation when game isn't won
                Color.clear.onAppear { progress = 0 }
            }
        }
    }
    
    private func getLinePositions(in geometry: GeometryProxy) -> Line {
        
        if let (startCell, endCell) = game.getWinLineEndPoints() {
            let line = CGVector(dx: endCell.column - startCell.column, dy: endCell.row - startCell.row)
            
            let minDimension = min(geometry.size.width, geometry.size.height)
            let cellSize: CGFloat = minDimension / CGFloat(game.size)
            
            let start = CGPoint(
                x: (cellSize * CGFloat(startCell.column)) + (cellSize / 2),
                y: cellSize / 2 + cellSize * CGFloat(startCell.row)
            )
            let end = CGPoint(
                x: start.x + line.dx * cellSize,
                y: start.y + line.dy * cellSize
            )
            let modifier = startCell.id > endCell.id ? CGFloat(cellSize / 2) : CGFloat(-(cellSize / 2))
            
            return addOffset(line: (start, end), on: line, amount: modifier)
        }
        return (start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0))
    }
    
    private func addOffset(line: Line, on vector: CGVector, amount: CGFloat ) -> Line {
        var start = line.start
        var end = line.end
        
        if vector.dx == 0 {
            start.y += amount
            end.y -= amount
        } else if vector.dy == 0 {
            start.x += amount
            end.x -= amount
        } else if vector.dy / vector.dx > 0 {
            start.x += amount
            end.x -= amount
            start.y += amount
            end.y -= amount
        } else {
            start.x -= amount
            end.x += amount
            start.y += amount
            end.y -= amount
        }
        return (start: start, end: end)
    }
}
