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
    @ObservedObject var game: ImageTicTacToeGame
    let start: CGPoint
    let end: CGPoint
    let color: Color
   
    @State var progress = CGFloat.zero
    
    var body: some View {
        GeometryReader { geometry in
            if game.winner != nil {
                let (start, end) = getLinePositions(in: geometry, from: start, to: end)
                winLine(paths: [start, end])
                    .trim(from: 0, to: progress)
                    .stroke(color, style: StrokeStyle(lineWidth: 5, lineCap: .round))
                    .onAppear {
                        withAnimation(.easeInOut(duration: 1)) { progress = 1.0 }
                    }
            } else {
                /// resets the animation when game isn't won
                Color.clear.onAppear { progress = 0 }
            }
        }
    }
    
    func getLinePositions(in geometry: GeometryProxy, from beginning: CGPoint = CGPoint(x: 0,y: 0), to end: CGPoint = CGPoint(x: 0,y: 0)) -> (start: CGPoint, end: CGPoint) {
        var start: (row: Int, col: Int)
        var finish: (row: Int, col: Int)
        
        start = (row: Int(beginning.x), col: Int(beginning.y))
        finish = (row: Int(end.x), col: Int(end.y))
        
        let deltaX = finish.col - start.col
        let deltaY = finish.row - start.row
        
        let minDimension = Int(min(geometry.size.width, geometry.size.height))
        let maxDimension = Int(max(geometry.size.width, geometry.size.height))
        let cellSize = minDimension / game.size
        let gridStartY = (maxDimension - minDimension) / 2
        
        var startX = (cellSize * start.col) + (cellSize / 2)
        var startY = gridStartY + cellSize / 2 + cellSize * start.row
        
        var endX = startX + deltaX * cellSize
        var endY = startY + deltaY * cellSize
        
        let slope = finish.col - start.col != 0 ? (finish.row - start.row) / (finish.col - start.col) : nil
        if let slope {
            if slope == 0 {
                startX -= cellSize / 2
                endX += cellSize / 2
            } else if slope == -1 {
                startX += cellSize / 2
                startY -= cellSize / 2
                endX -= cellSize / 2
                endY += cellSize / 2
            } else if slope == 1 {
                startX -= cellSize / 2
                startY -= cellSize / 2
                endX += cellSize / 2
                endY += cellSize / 2
            }
            
        } else {
            startY -= cellSize / 2
            endY += cellSize / 2
        }
        return (start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
}
