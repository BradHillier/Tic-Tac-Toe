//
//  ConnectionBoardGame.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-08-27.
//

import Foundation

protocol ConnectionBoardGame: TurnBasedGridGame {
   
    var connectionsToWin: Int { get set }
    
    mutating func choose(cell: Board.Cell) -> Bool
    
    /**
     Check if any groups of cells contained within `path` meet the win condition
     */
    func winningPath(in path: [Board.Cell]) -> Bool
    func winningCells() -> Array<Board.Cell>?
    
    /// this should be turned into an array extension
    /**
    return the `Player` who has the most consectutive occurences in the provided group coupled with the count of those occurences
     
    - Complexity:
    O(n), where n is the number of `Cell`'s in the provided `group`
     
    - Parameters:
        - group: the group in which to count consecutive cells containing the same player
    */
    func longestPlayerSubArray(in group: Array<Board.Cell>) -> Array<Board.Cell>
    
    /// this belongs on grid
    func seperate(group: Array<Board.Cell>, exclude: Content?) -> Array<[Board.Cell]>
}

extension ConnectionBoardGame {

    func winningPath(in path: [Board.Cell]) -> Bool {
        let slice = longestPlayerSubArray(in: path)
        if slice.count >= connectionsToWin {
            return true
        }
        return false
    }
    
    func winningCells() -> Array<Board.Cell>? {
        let possibleWinPaths = board.columns() + board.rows() + board.diagonals()
        for path in possibleWinPaths {
            var slice = longestPlayerSubArray(in: path)
            if slice.count >= connectionsToWin {
                if slice.last == moves.last {
                    slice.reverse()
                }
                return slice
            }
        }
        return nil
    }
    
    func longestPlayerSubArray(in group: Array<Board.Cell>) -> Array<Board.Cell> {
        let s = seperate(group: group, exclude: nil)
        let m = s.max { $0.count < $1.count } ?? []
        return m
    }
    
    func seperate(group: Array<Board.Cell>, exclude: Content?) -> Array<[Board.Cell]> {
        var arr = Array<Array<Board.Cell>>()
        var curr = Array<Board.Cell>()
        var currentContent: Content?
        for cell in group {
            if cell.content != currentContent {
                currentContent = cell.content
                if !curr.isEmpty {
                    if !curr.contains(where: { $0.content ==  exclude }) {
                        arr.append(curr)
                    }
                    curr.removeAll()
                }
            }
            curr.append(cell)
        }
        if !curr.contains(where: { $0.content == exclude }) {
            arr.append(curr)
        }
        return arr
    }
}

