//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import Foundation

struct TicTacToe<CellContent> {
    
    private var currentPlayer: Player
    private var gridSize: Int
    private(set) var board: Grid<Player?>
    
    enum Player {
        case X
        case Y
        
        static prefix func !(right: TicTacToe<CellContent>.Player) -> Player {
            switch right {
            case .X:
                return .Y
            case .Y:
                return .X
            }
        }
    }
    
    static func emptyGameBoard(size: Int) -> Grid<Player?> {
        let emptyBoard = Grid<Player?>(size: size)
        return emptyBoard
    }
    
    init(gridSize: Int) {
        self.gridSize = gridSize
        board = TicTacToe.emptyGameBoard(size: gridSize)
        currentPlayer = .X
    }
    
    mutating func choose(cell: Grid<Player?>.Cell) {
        board.changeContent(of: cell, to: currentPlayer)
        currentPlayer = !currentPlayer
    }
    
    func winner() -> Player? {
        // TODO: make this adapt to X number of players
        for player in [Player.X, Player.Y] {
            for row in board.rows() {
                if row.allSatisfy({ $0.content == player }) { return player }
            }
            for column in board.columns() {
                if column.allSatisfy({ $0.content == player }) { return player }
            }
        }
        return nil
    }
    
    func isTerminal() -> Bool {
        return winner() != nil || board.isFull()
    }
    
    mutating func reset() {
        board = TicTacToe.emptyGameBoard(size: 3)
        currentPlayer = .X
    }

}
