//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import Foundation

struct TicTacToe {
    
    private(set) var currentPlayer: Player
    private(set) var gridSize: Int
    private(set) var board: Grid<Player?>
    private var moves = Array<Grid<Player?>.Cell>()
    private var undoneMoves = Array<Grid<Player?>.Cell>()
    
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
            if let successfulMove = board.changeContent(of: cell, to: currentPlayer) {
                moves.append(successfulMove)
                currentPlayer = !currentPlayer
                undoneMoves.removeAll()
            }
            
        }
    }
    
    mutating func undo() {
        if !moves.isEmpty {
            let cell: Grid<Player?>.Cell = moves.removeLast()
            if let successfulUndo = board.changeContent(of: cell, to: nil) {
                undoneMoves.append(successfulUndo)
                currentPlayer = !currentPlayer
            }
        }
    }
    
    mutating func redo() {
        if !undoneMoves.isEmpty {
            let cell = undoneMoves.removeLast()
            if let successfulMove = board.changeContent(of: cell, to: currentPlayer) {
                moves.append(successfulMove)
                currentPlayer = !currentPlayer
            }
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
        moves.removeAll()
        undoneMoves.removeAll()
    }

}
