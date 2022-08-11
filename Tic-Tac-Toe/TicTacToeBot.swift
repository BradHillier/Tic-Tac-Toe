//
//  TicTacToeBot.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-20.
//

import Foundation

/// - Todo: Move to TicTacToe struct
extension TicTacToe {
    var availableMoves: [Board.Cell] { self.board.cells.filter({ $0.content == nil }) }
    
    var lastMove: Board.Cell? { self.moves.last }
    
    func display(_ scores: [(Board.Cell, Int)]?) {
        
        var copy = scores
        
        for row in board.rows() {
            print("-------")
            row.forEach{ cell in
                print("|", terminator: "")
                if let content = cell.content {
                    let repr = content == .X ? "X" : "O"
                    print(repr, terminator: "")
                } else {
                    if let repr = copy?.remove(at: 0) {
                        print(repr.1, terminator: "")
                    } else {
                        print(" ", terminator: "")
                    }
                }
            }
            print("|")
        }
        print("-------")
    }
}


struct TicTacToeBot {
    
    typealias Game = Grid<TicTacToe.Player?>
    
    // the maximum depth of the search tree
    let MaxDepth = 1
    
    /// returns the optimal move for the provided games current player
    func optimalMove(_ game: TicTacToe) -> Game.Cell? {
        
        var moveValue: Int
        
        /// array of available moves and their heuristic value
        var scores = Array<(Game.Cell, Int)>()
        
        /// a mutable copy of the provided TicTacToe game
        var copy: TicTacToe
        
        if game.isTerminal() {
            return nil
        }
        for move in game.availableMoves {
            copy = game
            copy.choose(cell: move)
            moveValue = getValue(of: copy, depth: MaxDepth)
            scores.append( (move, moveValue) )
        }
        scores.shuffle()
        scores.sort(by: {$0.1 > $1.1} )
        return game.currentPlayer == .X ? scores.first!.0 : scores.last!.0
    }
    
    /// recursive implementation of the mini-max algorithm, searches for the heuristic value of the provided `game` if both players are playing optimally
    ///
    /// - Returns: the heuristic value of `game`  after `depth` number of turns
    private func getValue(of game: TicTacToe, depth: Int) -> Int {
        
        let minOrMax: (Int, Int) -> Int = game.currentPlayer == .X ? max : min
        
        /// defaults to negative infinity when representing current maximum value and infinity when representing current minimum value
        var currentValue = game.currentPlayer == .X ? Int.min: Int.max
        
        /// a mutable copy of the provided TicTacToe game
        var copy: TicTacToe
        
        if depth == 0 || game.isTerminal() {
            return utility(of: game)
        }
        for move in game.availableMoves {
            copy = game
            copy.choose(cell: move)
            currentValue = minOrMax(currentValue, getValue(of: copy, depth: depth-1))
        }
        return currentValue
    }
    
    /// Returns the heuristic value of `board`'s current state
    private func utility(of board: TicTacToe) -> Int {
        if let winner = board.winner() {
            switch winner {
                case .X: return 1
                case .O: return -1
            }
        }
        return 0
    }
}
