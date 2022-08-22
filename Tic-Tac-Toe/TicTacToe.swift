//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//


import Foundation

/**
 a model of game of tictactoe
 
 - todo: check for a winner after a move, only checking the paths off of the move; have a flag on TicTacToe for the winner maybe a Player?
 */
struct TicTacToe {
    
    typealias Board = Grid<Player?>
    
    /// the `Player` who will take the first turn at the start of a new game
    static private let defaultPlayer: Player = .X
    
    let WinCondition: Int
    
    /// the `Player` who is currently taking a turn
    private(set) var currentPlayer = defaultPlayer
    
    /// the number of `Grid.Cell`'s contained in each row and column of the `Board`
    let size: Int
    
    /// a `Grid` of `Player?` representing the state of the `TicTacToe` game
    private(set) var board: Board
    
    /// all moves taken since the games initial state
    private(set) var moves = Array<Board.Cell>()
    private var undoneMoves = Array<Board.Cell>()
    
    /// Returns a `Grid` containing `nil` `Player` optionals of the provided size
    static func emptyGameBoard(size: Int) -> Board {
        let emptyBoard = Grid<Player?>(size: size)
        return emptyBoard
    }
    
    
    /**
    Creates a new instance with an empty game board of size `gridSize`
     
     - Parameters:
        - size: the number of cells in each of the grid's rows and columns
     */
    init(size: Int, winCondition: Int = 3) {
        self.size = size
        WinCondition = winCondition
        board = TicTacToe.emptyGameBoard(size: size)
    }
    
    /**
     Change the content of the provided `cell` to the current `Player`;
     only if the cell isn't already taken and the game isn't over
     
     - Returns:
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
                return true
            }
        }
        return false
    }
    
   /**
    Undo the most recent move
    
    Undoes the most recently performed move and stores it in `undoneMoves`.
    Sets the `currentPlayer` to the `Player` whose move was undone
    
    - Returns:
    `true` if a move was successfully undone; otherwise `false`
    */
    mutating func undo() -> Bool {
        if !moves.isEmpty {
            let cell: Grid<Player?>.Cell = moves.removeLast()
            if let successfulUndo = board.changeContent(of: cell, to: nil) {
                undoneMoves.append(successfulUndo)
                currentPlayer = !currentPlayer
                return true
            }
        }
        return false
    }
    
    /**
    redo the mostly recently undone move
     
    Redoes the most recently undone move and stores it in `moves`.
    Set current player to the next players turn
    
    - Returns:
    `true` if a move was successfully redone; otherwise `false`
    */
    mutating func redo() -> Bool {
        
        /// the `Grid.Cell` containing the most recently undone move
        let cell: Board.Cell
        
        if !undoneMoves.isEmpty {
            cell = undoneMoves.removeLast()
            if let successfullyRedoneMove = board.changeContent(of: cell, to: currentPlayer) {
                moves.append(successfullyRedoneMove)
                currentPlayer = !currentPlayer
                return true
            }
        }
        return false
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
        
        /// all potential paths on which a player could meet the win condition
        let possibleWinPaths = board.columns() + board.rows() + board.diagonals()
        
        for path in possibleWinPaths {
            if let slice = maxPlayerOccurences(in: path) {
                if slice.count >= WinCondition {
                    if let player = slice.first?.content {
                        return player
                    }
                }
            }
        }
        return nil
    }
    
    func winningCells() -> ArraySlice<Board.Cell>? {
        let possibleWinPaths = board.columns() + board.rows() + board.diagonals()
        
        for path in possibleWinPaths {
            if let slice = maxPlayerOccurences(in: path) {
                return slice
            }
        }
        return nil
    }
    
    /**
    Returns `true` if  a player has won the game or there are no available moves left on the board;
    otherwise return `false`
     */
    func isTerminal() -> Bool {
        return winner() != nil || board.isFull()
    }
    
    /**
    Restore the game to it's initial state
     
    Resets the content of the game board, sets the current player to the default player and removes knowledge of previously taken moves
    */
    mutating func reset() {
        board = TicTacToe.emptyGameBoard(size: size)
        currentPlayer = TicTacToe.defaultPlayer
        moves.removeAll()
        undoneMoves.removeAll()
    }
    
    /**
    return the `Player` who has the most consectutive occurences in the provided group coupled with the count of those occurences
     
    - Complexity:
    O(n), where n is the number of `Cell`'s in the provided `group`
     
    - Todo:  add labels to the return values in the tuple
     
    - Parameters:
        - group: the group in which to count consecutive cells containing the same player
     
    */
    func maxPlayerOccurences(in group: Array<Board.Cell>) -> ArraySlice<Board.Cell>? {
        
        /// the current greatest number of consecutive occurences of any player in the provided `group`
        var maxOccurences = 0
        
        /// the player who has currently appeared consecutively the greatest number of times
        var maxPlayer: Player?
        
        /// the current number of consecutive occurences of some player
        var currentOccurences = 0
        
        var currentPlayer: Player?
        
        var start: Int?
        var end: Int?
        
        var maxStart: Int?
        var maxEnd: Int?
        
        for (index, cell) in group.enumerated() {
            if cell.content == currentPlayer {
                currentOccurences += 1
                if currentOccurences > maxOccurences {
                    maxOccurences = currentOccurences
                    maxPlayer = currentPlayer
                    maxStart = start
                }
            } else {
                if let player = cell.content {
                    currentOccurences = 1
                    currentPlayer = player
                    start = index
                } else {
                    currentOccurences = 0
                }
            }
            end = index
            if currentOccurences == maxOccurences {
                maxEnd = end
            }
        }
        if let s = maxStart {
            if let e = maxEnd {
                return group[s...e]
            }
        }
        return nil
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
