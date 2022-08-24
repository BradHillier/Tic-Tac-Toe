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
    
    func getLinePositions(in geometry: GeometryProxy) -> (start: CGPoint, end: CGPoint) {
        
        if let (start, finish) = game.getWinLineEndPoints() {
            let deltaX = finish.column - start.column
            let deltaY = finish.row - start.row
            
            let minDimension = Int(min(geometry.size.width, geometry.size.height))
            let maxDimension = Int(max(geometry.size.width, geometry.size.height))
            let cellSize = minDimension / game.size
            let gridStartY = (maxDimension - minDimension) / 2
            
            var startX = (cellSize * start.column) + (cellSize / 2)
            var startY = gridStartY + cellSize / 2 + cellSize * start.row
            
            var endX = startX + deltaX * cellSize
            var endY = startY + deltaY * cellSize
            
            let slope = finish.column - start.column != 0 ? (finish.row - start.row) / (finish.column - start.column) : nil
            let startID = start.row * game.size + start.column
            let finishID = finish.row * game.size + finish.column
            
            let sign = {
                if startID > finishID {
                    return 1
                }
                return -1
            }()
            
            /// adjusts line depending on the slope of the winning cells
            if let slope {
                if slope == 0 {
                    startX += cellSize / 2 * sign
                    endX += cellSize / 2 * -sign
                } else if slope == -1 {
                    startX += cellSize / 2 * -sign
                    startY += cellSize / 2 * sign
                    endX += cellSize / 2 * sign
                    endY += cellSize / 2 * -sign
                } else if slope == 1 {
                    startX += cellSize / 2 * sign
                    startY += cellSize / 2 * sign
                    endX += cellSize / 2 * -sign
                    endY += cellSize / 2 * -sign
                }
                
            } else {
                startY += cellSize / 2 * sign
                endY += cellSize / 2 * -sign
            }
            return (start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
            
        }
        
        return (start: CGPoint(x: 0, y: 0), end: CGPoint(x: 0, y: 0))
    }
}
