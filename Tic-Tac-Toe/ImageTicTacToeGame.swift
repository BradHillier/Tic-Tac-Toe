//
//  ImageTicTacToeGame.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//


import SwiftUI

class ImageTicTacToeGame: ObservableObject {
    @Published private var game: TicTacToe
    
    init() {
        game = TicTacToe(size: 5)
    }
    
    var bot = TicTacToeBot()
    
    var size: Int { return game.size }
    var board: [Grid<TicTacToe.Player?>.Cell] { return game.board.cells }
    var isTerminal: Bool { return game.isTerminal() }
    var winner: TicTacToe.Player? { return game.winner() }
    var currentPlayer: TicTacToe.Player? { return game.currentPlayer }
    
    
    func choose(_ cell: Grid<TicTacToe.Player?>.Cell) {
        game.choose(cell: cell)
        aiMove()
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
    
    func aiMove() {
        if let move = bot.optimalMove(game) {
            game.choose(cell: move)
        }
    }
    
}
