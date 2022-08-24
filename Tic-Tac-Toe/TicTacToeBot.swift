//
//  TicTacToeBot.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-20.
//

import Foundation

/// - Todo: Move to TicTacToe struct
extension TicTacToe {

    
    func display(_ scores: [(Board.Cell, Int, Int)]?) {
        
        var copy = scores
        
        for row in board.rows() {
            print("-------------------------")
            print("|   |    |    |    |    |")
            row.forEach{ cell in
                print("|", terminator: "")
                if let content = cell.content {
                    let repr = content == .X ? "  X  " : "  O  "
                    print(repr, terminator: "")
                } else {
                    if let repr = copy?.remove(at: 0) {
                        print((repr.1), terminator: "")
                    } else {
                        print(" ", terminator: "")
                    }
                }
            }
            print("|")
        print("|   |    |    |    |    |")
        }
        print("-------------------------")
    }
    
    func display() {
    
    for row in board.rows() {
        print("-------")
        row.forEach{ cell in
            print("|", terminator: "")
            if let content = cell.content {
                let repr = content == .X ? "X" : "O"
                print(repr, terminator: "")
            } else {
                print(" ", terminator: "")
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
    let MaxDepth: Int
   
    /**
    returns the optimal move for the provided games current player
     
     - Parameters:
        - game: the `TicTacToe` game whose state will be used to find the optimal move for its current player
     
     - Returns: the `Cell` the current player should use; otherwise `nil` if `game` is in a terminal state
     */
    func optimalMove(_ game: TicTacToe) -> Game.Cell? {
        
        /// the heuristic value of the move currently being explored
        var moveValue: Int
        
        var depthFound: Int
        
        /// array of available moves and their heuristic value
        var scores = Array<(Game.Cell, Int, Int)>()
        
        /// a mutable copy of the provided TicTacToe game
        var copy: TicTacToe
        
        var maxValue = Int.min
        var minValue = Int.max
        
        if game.isTerminal() {
            return nil
        }
        for move in game.availableMoves {
            copy = game
            if copy.choose(cell: move) {
                (moveValue, depthFound) = getValue(of: copy, highest: maxValue, lowest: minValue)
                if moveValue > maxValue {
                    maxValue = moveValue
                } else if moveValue < minValue {
                   minValue = moveValue
                }
                scores.append( (move, moveValue, depthFound) )
            }
        }
        if scores.allSatisfy({ $0.1 == scores.first?.1}) {
            scores = game.availableMoves.map({ move in
                var copy = game
                copy.choose(cell: move)
                return (move, moveUtility(copy), 1)
            })
        }
        // shuffling before sorting results in scores of the same value appearing
        // in random order once sorted
        game.display(scores)
        scores.shuffle()
        scores.sort { $0.1 > $1.1 }
        return game.currentPlayer == .X ? scores.first!.0 : scores.last!.0
    }
    /**
    recursive implementation of the mini-max algorithm, searches for the heuristic value of the provided `game` if both players are playing optimally
     
     higher outputs indicate the state of the game favors .X, while lower outputs indicate the state favors .O
     
    - Returns:
     a tuple containing:
        0) the heuristic value of `game`  after `depth` number of turns, assuming both players continue to play optimally;
        1) the number of moves ahead the heuristic was taken
    - Parameters:
        - game: the `TicTacToe` game whose state will be transformed into a heuristic value
    */
    private func getValue(of game: TicTacToe, depth: Int=1, highest: Int, lowest: Int) -> (Int, Int) {
    
    /// a mutable copy of the provided TicTacToe game
    var copy: TicTacToe
        
    var moveValue: Int
        
    var depthFound: Int = depth
    
    if depth >= MaxDepth || game.isTerminal() {
        return (utility(of: game, movesAway: depth), depth)
    }
    switch game.currentPlayer {
        
    /// the player trying to maximize the board heuristic
    case .X:
        var maximumGuaranteedValue = Int.min
        
        for move in game.availableMoves {
            copy = game
            if copy.choose(cell: move) {
                (moveValue, depthFound) = getValue(of: copy, depth: depth+1, highest: maximumGuaranteedValue, lowest: lowest)
                maximumGuaranteedValue = max(maximumGuaranteedValue, moveValue)
                if lowest < maximumGuaranteedValue {
                    break
                }
            }
        }
        return (maximumGuaranteedValue, depthFound)
        
    /// the player trying to minimize the heuristic
    case .O:
        var minimumGuaranteedValue = Int.max
        
        for move in game.availableMoves {
            copy = game
            if copy.choose(cell: move) {
                (moveValue, depthFound) = getValue(of: copy, depth: depth+1, highest: highest, lowest: minimumGuaranteedValue)
                minimumGuaranteedValue = min(minimumGuaranteedValue, moveValue)
                
                /// assuming the X player is playing optimally, this branch of the game is unlikely to be created, and thus, isn't worth further exploration.
                if highest > minimumGuaranteedValue {
                    break
                }
            }
        }
        return (minimumGuaranteedValue, depthFound)
    }
}
    
    /// Returns the heuristic value of `board`'s current state
    private func utility(of board: TicTacToe, movesAway: Int) -> Int {
        
        if let winner = board.winner() {
            switch winner {
                case .X:
                return 10000 + (winner == .X ? -movesAway : movesAway)
                case .O:
                return -10000 - (winner == .O ? movesAway : -movesAway)
            }
        }
        return 0
    }
    
    private func moveUtility(_ game: TicTacToe) -> Int {
        
        let lanes = game.board.rows() + game.board.columns() + game.board.diagonals()
        
        let lanesContainingMove = lanes.filter { $0.contains { cell in cell.id == game.lastMove!.id } }
        
        var score = 0
        
        lanesContainingMove.forEach { lane in
            let playerCount = lane.filter({ $0.content != nil }).count
            let currPlayerCount = lane.filter({ $0.content == game.currentPlayer }).count
            let previousPlayerCount = lane.filter({ $0.content == !game.currentPlayer }).count
            
            if playerCount == 1 {
                score += 1
            } else if playerCount == 2 {
                score += 10
            } else {
                score += 100
            }
            if previousPlayerCount == playerCount || currPlayerCount ==  playerCount - 1 {
                score += 100 * playerCount
            }
            if currPlayerCount >= game.WinCondition - 1 {
                score += 500
            }
            if game.winner() == game.lastMove!.content {
                score += 1000
            }
        }
        return game.moves.last?.content == .X ? score : -score
    }
}
