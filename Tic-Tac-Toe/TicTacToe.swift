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
struct TicTacToe: ConnectionBoardGame {
    
    static var defaultPlayer: Player = .X
    
    typealias Board = Grid<Player?>
    
    var board: Board
    var moves = Array<Board.Cell>()
    var undoneMoves = Array<Board.Cell>()
    var currentPlayer = TicTacToe.defaultPlayer
    var connectionsToWin: Int
    
    var winner: Player?
    
    /**
    Creates a new instance with an empty game board of size `gridSize`
     
     - Parameters:
        - size: the number of cells in each of the grid's rows and columns
     */
    init(size: Int, condition: Int = 3) {
        board = TicTacToe.emptyGameBoard(size: size)
        self.connectionsToWin = condition
        currentPlayer = TicTacToe.defaultPlayer
    }
    
    func isWon() -> Bool {
        if !moves.isEmpty  {
            if let last = board.groups(containing: lastMove!) {
                return last.contains { winningPath(in: $0) }
            }
        }
        return false
    }
    
    func isTerminal() -> Bool {
        return winner != nil || board.isFull()
    }
    
    var availableMoves: Set<Board.Cell> {
        Set(moves.flatMap { cell in
            board.adjacent(to: cell).filter { $0.content == nil }
        })
    }
    
    func nextPlayer() -> Player {
        switch currentPlayer {
        case .X: return .O
        case .O: return .X
        }
    }
    
    /**
     Change content of `cell` to `currentPlayer` iff the cell isn't already taken and the game isn't over
     
     - Returns:
     `true` if the cell was successfully chosen; otherwise `false`
     
     - parameters:
            - cell: The cell the current player is attemping to choose.
     */
    mutating func choose(cell: Board.Cell) -> Bool {
        if cell.isEmpty() && winner == nil {
            if let successfulMove = board.changeContent(of: cell, to: currentPlayer) {
                moves.append(successfulMove)
                if isWon() {
                    winner = currentPlayer
                }
                currentPlayer = nextPlayer()
                undoneMoves.removeAll()
                return true
            }
        }
        return false
    }



    mutating func reset() {
        board = TicTacToe.emptyGameBoard(size: board.size)
        currentPlayer = TicTacToe.defaultPlayer
        winner = nil
        moves.removeAll()
        undoneMoves.removeAll()
    }
    
    /// Represents either the X player or the O player in a game of Tictactoe
    enum Player: CaseIterable, Hashable {
        case X, O

    }
}

