//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import Foundation

struct TicTacToe {
    
    private var currentPlayer: Player
    private(set) var gridSize: Int
    private(set) var board: Grid<Player?>
    private var moves = Array<Grid<Player?>.Cell>()
    
    enum Player: CaseIterable {
        case X, O
        
        static prefix func !(right: TicTacToe.Player) -> Player {
            switch right {
            case .X:
                return .O
            case .O:
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
        if cell.isEmpty() && winner() == nil {
            board.changeContent(of: cell, to: currentPlayer)
            moves.append(cell)
            currentPlayer = !currentPlayer
        }
    }
    
    mutating func undo() {
        if !moves.isEmpty {
            let move: Grid<Player?>.Cell = moves.removeLast()
            board.changeContent(of: move, to: nil)
            currentPlayer =  !currentPlayer
        }
        
    }
    
    func winner() -> Player? {
        for player in Player.allCases {
            for row in board.rows() {
                if row.allSatisfy({ $0.content == player }) { return player }
            }
            for column in board.columns() {
                if column.allSatisfy({ $0.content == player }) { return player }
            }
            var diagonalLeft = [Grid<Player?>.Cell]()
            var diagonalRight = [Grid<Player?>.Cell]()
            for index in 0..<gridSize {
                diagonalLeft.append(board.rows()[index][index])
                diagonalRight.append(board.rows()[(gridSize - 1) - index][index])
            }
            if diagonalLeft.allSatisfy({ $0.content == player }) { return player }
            if diagonalRight.allSatisfy({ $0.content == player }) { return player }
            
        }
        return nil
    }
    
    func isTerminal() -> Bool {
        return winner() != nil || board.isFull()
    }
    
    mutating func reset() {
        board = TicTacToe.emptyGameBoard(size: gridSize)
        currentPlayer = .X
    }

}
