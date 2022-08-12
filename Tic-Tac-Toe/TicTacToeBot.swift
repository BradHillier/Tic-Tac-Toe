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


/// uses a minimax algorithm to find a reasonable move for the current player, either X or O, of a TicTacToe game
struct TicTacToeBot {
    
    typealias Game = Grid<TicTacToe.Player?>
    
    // the maximum depth of the search tree
    let MaxDepth = 1
   
    /**
    returns the optimal move for the provided games current player
     
     - Parameters:
        - game: the `TicTacToe` game whose state will be used to find the optimal move for its current player
     
     - Returns: the `Cell` the current player should use; otherwise `nil` if `game` is in a terminal state
     */
    func optimalMove(_ game: TicTacToe) -> Game.Cell? {
        
        /// the heuristic value of the move currently being explored
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
        // shuffling before sorting results in scores of the same value appearing
        // in random order once sorted
        scores.shuffle()
        scores.sort(by: {$0.1 > $1.1} )
        return game.currentPlayer == .X ? scores.first!.0 : scores.last!.0
    }
    /**
    recursive implementation of the mini-max algorithm, searches for the heuristic value of the provided `game` if both players are playing optimally
     
     higher outputs indicate the state of the game favors .X, while lower outputs indicate the state favors .O
     
    - Returns: the heuristic value of `game`  after `depth` number of turns, assuming both players continue to play optimally;
    - Parameters:
        - game: the `TicTacToe` game whose state will be transformed into a heuristic value
    */
    private func getValue(of game: TicTacToe, depth: Int) -> Int {
        
        /// used to find the heuristic of the move currently being looked at
        let minOrMax: (Int, Int) -> Int = game.currentPlayer == .X ? max : min
        
        /// defaults to negative infinity when representing current maximum value and infinity when representing current minimum value
        ///  represents the current largest heuristic found when current player is .X
        ///  or the small heuristic value found when current player is .O
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
