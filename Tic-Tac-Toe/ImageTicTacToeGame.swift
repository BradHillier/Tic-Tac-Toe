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
        game = TicTacToe(gridSize: 4)
    }
    
    var board: [Grid<TicTacToe.Player?>.Cell] { return game.board.asLinearArrangement }
    
    var size: Int { return game.gridSize }
    
    func choose(_ cell: Grid<TicTacToe.Player?>.Cell) {
        game.choose(cell: cell)
    }
    
    func getValue(of cell: Grid<TicTacToe.Player?>.Cell) -> String {
        print(game)
        switch cell.content {
        case .X:
            return "X"
        case .O:
            return "O"
        default:
            return " "
        }
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
}
