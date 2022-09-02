//
//  GridGame.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-08-26.
//

import Foundation


struct Command<Game: TurnBasedGridGame, AssociatedData> {
    var board: Game.Board?
    let data: AssociatedData
    let action: (inout Game) -> Void
    
    func undo(on game: inout Game) -> Void {
        if let board {
            game.board = board
        }
    }
    
    mutating func execute(on game: inout Game) -> Void {
        if board == nil {
            board = game.board
        }
        action(&game)
    }
}


protocol TurnBasedGridGame {
    associatedtype Content: Hashable
    associatedtype Player: CaseIterable
    associatedtype CommandData
    
    typealias Board = Grid<Content>
    
    var defaultPlayer: Player { get set }
    var currentPlayer: Player { get set }
    func nextPlayer() -> Player
    var winner: Player? { get set }
    
    /**
     if returns `true` sets the value of `winner` to the `currentPlayer`; otherwise ses `winner` to `nil`
     */
    func isWon() -> Bool
    var board: Board { get set }
    var moves: Array<Command<Self, CommandData>> { get set }
    var undoneMoves: Array<Command<Self, CommandData>> { get set }
    
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
    static func emptyGameBoard(size: Int) -> Board
    
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
    @discardableResult
    mutating func redo() -> Bool
    
}


extension TurnBasedGridGame {
    
    static func emptyGameBoard(size: Int) -> Board {
        let emptyBoard = Board(size: size)
        return emptyBoard
    }
    
    mutating func perform(_ action: Command<Self, CommandData>) {
        var mutableAction = action
        mutableAction.execute(on: &self)
        moves.append(mutableAction)
        undoneMoves.removeAll()
        if isWon() {
            winner = currentPlayer
        } else {
            currentPlayer = nextPlayer()
        }
    }
   
    @discardableResult
    mutating func undo() -> Bool {
        if let action = moves.popLast() {
            action.undo(on: &self)
            undoneMoves.append(action)
            return true
        }
        return false
    }
    
    @discardableResult
    mutating func redo() -> Bool {
        if var action = undoneMoves.popLast() {
            action.execute(on: &self)
            moves.append(action)
            return true
        }
        return false
    }
    
    mutating func reset() {
        board = Self.emptyGameBoard(size: board.size)
        currentPlayer = defaultPlayer
        winner = nil
        moves.removeAll()
        undoneMoves.removeAll()
    }
}


