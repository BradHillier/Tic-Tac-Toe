//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import Foundation

struct TicTacToe {
    
    typealias Board = Grid<Player?>
    
    private(set) var currentPlayer: Player
    private(set) var gridSize: Int
    private(set) var board: Board
    private(set) var moves = Array<Board.Cell>()
    private var undoneMoves = Array<Board.Cell>()
    
    /// representing the players of a TicTacToe game\
    ///
    /// - Note: the is a test note
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
    
    /// Returns a `Grid` containing `nil` `Player` optionals of the provided size
    static func emptyGameBoard(size: Int) -> Board {
        let emptyBoard = Grid<Player?>(size: size)
        return emptyBoard
    }
    
    ///  Creates an instance with an empty board and `.X`
    init(gridSize: Int) {
        self.gridSize = gridSize
        board = TicTacToe.emptyGameBoard(size: gridSize)
        currentPlayer = .X
    }
    
    /// Change the content of the provided `cell` to the current `Player`;
    /// only if the cell isn't already taken and the game isn't over
    ///
    ///  - Parameter cell: The cell the current player is attempting to choose
    mutating func choose(cell: Board.Cell) {
        if cell.isEmpty() && winner() == nil {
            if let successfulMove = board.changeContent(of: cell, to: currentPlayer) {
                moves.append(successfulMove)
                currentPlayer = !currentPlayer
                undoneMoves.removeAll()
            }
            
        }
    }
    
    /// undo the most recent move
    mutating func undo() {
        if !moves.isEmpty {
            let cell: Grid<Player?>.Cell = moves.removeLast()
            if let successfulUndo = board.changeContent(of: cell, to: nil) {
                undoneMoves.append(successfulUndo)
                currentPlayer = !currentPlayer
            }
        }
    }
    
    /// redo the mostly recently undone move
    mutating func redo() {
        if !undoneMoves.isEmpty {
            let cell = undoneMoves.removeLast()
            if let successfulMove = board.changeContent(of: cell, to: currentPlayer) {
                moves.append(successfulMove)
                currentPlayer = !currentPlayer
            }
        }
    }
    
    /// Returns the winning Player of a TicTacToe instance
    ///
    ///  Checks for a winner horizontally, vertically, and diagonally
    /// - Complexity: O(n), where n is the size of the instance's board
    /// - Returns: the winning `Player` if there is one; `nil` otherwise.
    func winner() -> Player? {
        for player in Player.allCases {
            for row in board.rows() {
                if row.allSatisfy({ $0.content == player }) { return player }
            }
            for column in board.columns() {
                if column.allSatisfy({ $0.content == player }) { return player }
            }
            var diagonalTopLeftToBottomRight = [Board.Cell]()
            var diagonalBottomLeftToTopRight = [Board.Cell]()
            for index in 0..<gridSize {
                diagonalTopLeftToBottomRight.append(board.rows()[index][index])
                diagonalBottomLeftToTopRight.append(board.rows()[(gridSize - 1) - index][index])
            }
            if diagonalTopLeftToBottomRight.allSatisfy({ $0.content == player }) { return player }
            if diagonalBottomLeftToTopRight.allSatisfy({ $0.content == player }) { return player }
            
        }
        return nil
    }
    
    /// Returns`true` if the game is over or there are no available moves;
    /// otherwise return `false`
    func isTerminal() -> Bool {
        return winner() != nil || board.isFull()
    }
    
    /// Restore the game to it's initial state
    mutating func reset() {
        board = TicTacToe.emptyGameBoard(size: gridSize)
        currentPlayer = .X
        moves.removeAll()
        undoneMoves.removeAll()
    }
}
