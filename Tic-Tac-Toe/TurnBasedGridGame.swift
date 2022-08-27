//
//  GridGame.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-08-26.
//

import Foundation


protocol TurnBasedGridGame {
    associatedtype Content where Content: Hashable
    associatedtype Player where Player: CaseIterable
    
    var board: Grid<Content> { get set }
    var currentPlayer: Player { get set }
    func nextPlayer() -> Player
    static var defaultPlayer: Player { get set }
    var moves: Array<Grid<Content>.Cell> { get set }
    var undoneMoves: Array<Grid<Content>.Cell> { get set }
    var winner: Player? { get set }
    
    func isWon() -> Bool
    
    /**
    Returns `true` if  a player has won the game or there are no available moves left on the board;
    otherwise return `false`
     */
    func isTerminal() -> Bool
    

    
    /**
    Restore the game to it's initial state
     
    Resets the content of the game board, sets the current player to the default player and removes knowledge of previously taken moves
    */
    mutating func reset()
    
    /// Returns a `Grid` containing `nil` `Player` optionals of the provided size
    static func emptyGameBoard(size: Int) -> Grid<Content>
    
   /**
    Undo the most recent move
    
    Undoes the most recently performed move and stores it in `undoneMoves`.
    Sets the `currentPlayer` to the `Player` whose move was undone
    
    - Returns:
    `true` if a move was successfully undone; otherwise `false`
    */
    mutating func undo() -> Bool
    
    /**
    redo the mostly recently undone move
     
    Redoes the most recently undone move and stores it in `moves`.
    Set current player to the next players turn
    
    - Returns:
    `true` if a move was successfully redone; otherwise `false`
    */
    mutating func redo() -> Bool
}


extension TurnBasedGridGame {
    
   typealias Board = Grid<Content>
    
    var lastMove: Board.Cell? { self.moves.last }
    
    static func emptyGameBoard(size: Int) -> Grid<Content> {
        let emptyBoard = Grid<Content>(size: size)
        return emptyBoard
    }
    

    
    mutating func undo() -> Bool {
        if !moves.isEmpty {
            let cell: Grid<Content>.Cell = moves.removeLast()
            if let successfulUndo = board.changeContent(of: cell, to: nil) {
                undoneMoves.append(successfulUndo)
                currentPlayer = nextPlayer()
                winner = nil
                return true
            }
        }
        return false
    }
    
    mutating func redo() -> Bool {
        if !undoneMoves.isEmpty {
            let lastUndone = undoneMoves.removeLast()
            if let successfullyRedoneMove = board.changeContent(of: lastUndone, to: lastUndone.content) {
                moves.append(successfullyRedoneMove)
                currentPlayer = nextPlayer()
                return true
            }
        }
        return false
    }
    
}



