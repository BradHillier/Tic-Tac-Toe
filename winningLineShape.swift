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
                        withAnimation(.easeInOut(duration: 0.5)) { progress = 1.0 }
                    }
            } else {
                /// resets the animation when game isn't won
                Color.clear.onAppear { progress = 0 }
            }
        }
    }
    
    private func getLinePositions(in geometry: GeometryProxy) -> Line {
        
        if let (startCell, endCell) = game.getWinLineEndPoints() {
            let gridVector = CGVector(dx: endCell.column - startCell.column, dy: endCell.row - startCell.row)
            
            let minDimension = min(geometry.size.width, geometry.size.height)
            let cellSize: CGFloat = minDimension / CGFloat(game.size)
            
            let start = CGPoint(
                x: (cellSize * CGFloat(startCell.column)) + (cellSize / 2),
                y: cellSize / 2 + cellSize * CGFloat(startCell.row)
            )
            let end = CGPoint(
                x: start.x + gridVector.dx * cellSize,
                y: start.y + gridVector.dy * cellSize
            )
            return extendLine(from: start, to: end, by: cellSize / 2)
        }
        return (start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0))
    }
    
    private func extendLine(from start: CGPoint, to end: CGPoint, by amount: CGFloat ) -> Line {
        var extendedStart = start
        var extendedEnd = end
        let line = CGVector(dx: end.x - start.x, dy: end.y - start.y)
        
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
