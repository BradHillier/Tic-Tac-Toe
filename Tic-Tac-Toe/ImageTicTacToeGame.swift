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
    private var bot: TicTacToeBot
    
    init() {
        game = TicTacToe(size: 15, condition: 5)
        bot = TicTacToeBot(MaxDepth: 4)
    }
    
    var size: Int { return game.board.size }
    var board: [TicTacToe.Board.Cell] { return game.board.cells }
    var isTerminal: Bool { return game.isTerminal() }
    var winner: TicTacToe.Player? { return game.winner }
    var currentPlayer: TicTacToe.Player? { return game.currentPlayer }
    let inMultiplayerMode = true // this should be on the model
    
    var menu: Bool { game.onMenu }
    
    func playToggle() {
        game.onMenu = !menu
    }
    
    func choose(_ cell: TicTacToe.Board.Cell) {
        if let action = game.choose(cell: cell) {
            game.perform(action)
            if !inMultiplayerMode {
               aiMove()
            }
        }
    }
    
    func getValue(of cell: TicTacToe.Board.Cell) -> Image? {
        return image(of: cell.content)
    }
    
    func undo() {
        if !inMultiplayerMode {
        //    if game.winner == nil || game.moves.first!.player != game.winner {
                game.undo()
        //    }
        }
        game.undo()
    }
    
    func redo() {
        if !inMultiplayerMode {
            game.redo()
        }
        game.redo()
    }
    
    func reset() {
        game.reset()
    }
    
    /**
     - ToDo: change the type of value this takes
     */
    func image(of player: TicTacToe.Content??) -> Image? {
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
        if var cells = game.winningCells() {
            if cells.last == game.moves.last?.data.cell {
                cells.reverse()
            }
            if let first = cells.first, let last = cells.last {
                return (
                    start: CGPoint(x: first.column, y: first.row),
                    finish: CGPoint(x: last.column, y: last.row)
                )
            }
        }
        return nil
    }
    
    func newBoard(size: Int) {
        self.game = TicTacToe(size: size, condition: size > 3 ? 5 : 3)
    }
    
    func aiMove() {
        if let cell = bot.optimalMove(game) {
            if let action = game.choose(cell: cell) {
                game.perform(action)
            }
        }
    }
}
