//
//  ImageTicTacToeGame.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//


import SwiftUI

/**
 Acts as a view model for a game of TicTacToe
 */
class ImageTicTacToeGame: ObservableObject {
    @Published private var game: TicTacToe
    let bot: TicTacToeBot
    
    init() {
        game = TicTacToe(size: 10, condition: 5)
        bot = TicTacToeBot(MaxDepth: 2)
    }
    
    var size: Int { return game.board.size }
    var board: [Grid<TicTacToe.Player?>.Cell] { return game.board.cells }
    var isTerminal: Bool { return game.isTerminal() }
    var winner: TicTacToe.Player? { return game.winner }
    var currentPlayer: TicTacToe.Player? { return game.currentPlayer }
    var lastMove: TicTacToe.Board.Cell? { return game.lastMove }
    let inMultiplayerMode = false // this should be on the model
    
    func choose(_ cell: Grid<TicTacToe.Player?>.Cell) {
        if game.choose(cell: cell) {
            aiMove()
        }
    }
    
    func getValue(of cell: Grid<TicTacToe.Player?>.Cell) -> Image? {
        return image(of: cell.content)
    }
    
    func undo() {
        if inMultiplayerMode {
            if game.winner == nil || game.moves.first!.content != game.winner {
                game.undo()
            }
        }
        game.undo()
    }
    
    func redo() {
        if game.redo() {
            game.redo()
        }
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
    
    func getWinLineEndPoints() -> (start: CGPoint, finish: CGPoint)? {
        if let cells = game.winningCells() {
            if let first = cells.first, let last = cells.last {
                return (
                    start: CGPoint(x: first.column, y: first.row),
                    finish: CGPoint(x: last.column, y: last.row)
                )
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
