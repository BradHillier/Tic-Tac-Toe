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
    
    func getWinLineEndPoints() -> (CGPoint, CGPoint) {
        let cells = game.winningCells()
        let start = CGPoint(x: cells?.first?.row ?? 0, y: cells?.first?.column ?? 0)
        let end = CGPoint(x: cells?.last?.row ?? 0, y: cells?.last?.column ?? 0)
        return (start, end)
    }
    
    func aiMove() {
        if let move = bot.optimalMove(game) {
            game.choose(cell: move)
        }
    }
}
