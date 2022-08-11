//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//


import Foundation

struct TicTacToe {
    
    typealias Board = Grid<Player?>
    
    /// the `Player` who will take the first turn at the start of a new game
    static private let defaultPlayer: Player = .X
    
    /// the `Player` who is currently taking a turn
    private(set) var currentPlayer = defaultPlayer
    
    /// the number of `Grid.Cell`'s contained in each row and column of the `Board`
    private(set) var gridSize: Int
    
    /// a `Grid` of `Player?` representing the state of the `TicTacToe` game
    private(set) var board: Board
    private(set) var moves = Array<Board.Cell>()
    private var undoneMoves = Array<Board.Cell>()
    
    /// Returns a `Grid` containing `nil` `Player` optionals of the provided size
    static func emptyGameBoard(size: Int) -> Board {
        let emptyBoard = Grid<Player?>(size: size)
        return emptyBoard
    }
    
    ///  Creates an instance with an empty board and `.X` as the starting player
    init(gridSize: Int) {
        self.gridSize = gridSize
        board = TicTacToe.emptyGameBoard(size: gridSize)
        currentPlayer = .X
    }
    
    /**
     Change the content of the provided `cell` to the current `Player`;
     only if the cell isn't already taken and the game isn't over
     
     - returns:
     `true` if the cell was successfully chose; otherwise `false`
     
     - parameters:
            - cell: The cell the current player is attemping to choose.
     */
    mutating func choose(cell: Board.Cell) -> Bool {
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
    
    /**
    Returns the winning Player of a TicTacToe instance
    Checks for a winner horizontally, vertically, and diagonally
     
     - Returns:
     the winning `Player` if there is one; `nil` otherwise.
     
     - Complexity:
     O(n), where n is the number of possible win paths
     
    - Note:
     This could be made faster by by checking for either winner on a single pass of the possible win paths.
    */
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
    
    /**
    Returns`true` if  a player has won the game or there are no available moves left on the board;
    otherwise return `false`
     */
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
    
    /**
    return the `Player` who has the most consectutive occurences in the provided group coupled with the count of those occurences
     
    - Complexity:
    O(n), where n is the number of `Cell`'s in the provided `group`
     
    - Parameters:
        - group: the group in which to count consecutive cells containing the same player
    */
    private func maxPlayerSubset(in group: Array<Board.Cell>) -> (Player?, Int) {
        
        var maxOccurences = 0
        
        var maxPlayer: Player?
        
        var currentOccurences = 0
        
        if var currentPlayer = group.first?.content {
            for cell in group {
                if cell.content == currentPlayer {
                    currentOccurences += 1
                    if currentOccurences > maxOccurences {
                        maxOccurences = currentOccurences
                        maxPlayer = currentPlayer
                    }
                } else {
                    currentOccurences = 1
                    if let player = cell.content {
                        currentPlayer = player
                    }
                }
            }
        }
        return (maxPlayer, maxOccurences)
    }
    
    /// Represents either the X player or the O player in a game of Tictactoe
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
}
