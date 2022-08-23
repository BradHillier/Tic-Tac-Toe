//
//  ImageTicTacToeGame.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//


import SwiftUI

class ImageTicTacToeGame: ObservableObject {
    @Published private var game: TicTacToe
    let bot: TicTacToeBot
    
    init() {
        game = TicTacToe(size: 5, winCondition: 3)
        bot = TicTacToeBot(MaxDepth: 0)
    }
    
    
    var size: Int { return game.size }
    var board: [Grid<TicTacToe.Player?>.Cell] { return game.board.cells }
    var isTerminal: Bool { return game.isTerminal() }
    var winner: TicTacToe.Player? { return game.winner() }
    var currentPlayer: TicTacToe.Player? { return game.currentPlayer }
    
    
    func choose(_ cell: Grid<TicTacToe.Player?>.Cell) {
        game.choose(cell: cell)
    }
    
    func getValue(of cell: Grid<TicTacToe.Player?>.Cell) -> Image? {
        return image(of: cell.content)
    }
    
    func undo() {
        game.undo()
    }
    
    func redo() {
        game.redo()
    }
    
    func reset() {
        game.reset()
    }
    
    
    func image(of player: TicTacToe.Player??) -> Image? {
        switch player {
        case .X:
            return Image(systemName: "xmark")
        case .O:
            return Image(systemName: "circle")
        default:
            return nil
        }
        
    }
    
    func getLinePositions(width: CGFloat, height: CGFloat) -> (start: CGPoint, end: CGPoint) {
        var start: (row: Int, col: Int)
        var end: (row: Int, col: Int)
        
        if let cells = game.winningCells() {
            start = (row: cells.first!.row, col: cells.first!.column)
            end = (row: cells.last!.row, col: cells.last!.column)
        } else {
            /// - ToDo: remove this
            start = (row: 0, col: 0)
            end = (row: 0, col: 0)
        }
        let deltaX = end.col - start.col
        let deltaY = end.row - start.row
        
        let minDimension = Int(min(width, height))
        let maxDimension = Int(max(width, height))
        let cellSize = minDimension / game.size
        let gridStartY = maxDimension - minDimension
        
        let startX = (cellSize * start.col) + (cellSize / 2)
        let startY = gridStartY + cellSize / 2 + cellSize * start.row
        
        let endX = startX + deltaX * cellSize
        let endY = startY + deltaY * cellSize
        
        return (start: CGPoint(x: startX, y: startY), end: CGPoint(x: endX, y: endY))
    }
    
    func aiMove() {
        if let move = bot.optimalMove(game) {
            game.choose(cell: move)
        }
    }
}
