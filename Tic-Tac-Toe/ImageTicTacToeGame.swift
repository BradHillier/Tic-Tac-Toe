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
        game = TicTacToe(size: 10, winCondition: 3)
        bot = TicTacToeBot(MaxDepth: 0)
    }
    
    
    var size: Int { return game.size }
    var board: [Grid<TicTacToe.Player?>.Cell] { return game.board.cells }
    var isTerminal: Bool { return game.isTerminal() }
    var winner: TicTacToe.Player? { return game.winner() }
    var currentPlayer: TicTacToe.Player? { return game.currentPlayer }
    var lastMove: TicTacToe.Board.Cell? { return game.lastMove }
    
    
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
    
    func getWinLineEndPoints() -> (start: TicTacToe.Board.Cell, finish: TicTacToe.Board.Cell)? {
        var cells = game.winningCells()
        
        if var cells = cells {
            if let first = cells.first, let last = cells.last {
                
                // put the most recently played move at the start
                if last == game.lastMove {
                    return (last, first)
                }
                return (first, last)
            }
        }
        return nil
    }
    
    func aiMove() {
        if let move = bot.optimalMove(game) {
            game.choose(cell: move)
        }
    }
}
