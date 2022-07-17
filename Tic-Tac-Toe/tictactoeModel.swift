//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import Foundation

struct TicTacToe<CellContent> {
    
    private var currentPlayer: Player = .X
    private var gridSize: Int = 3
    private(set) var board: Grid<Player?>  = emptyGameBoard()
    
    enum Player {
        case X
        case Y
        
        static prefix func !(right: TicTacToe<CellContent>.Player) -> Player {
            switch right {
            case .X:
                return .Y
            case .Y:
                return .X
            }
        }
    }
    
    func choose(cell: Grid<CellContent>.Cell) {
        
    }
    
    static func emptyGameBoard() -> Grid<Player?> {
        let emptyBoard = Grid<Player?>(size: 3)
        return emptyBoard
    }
    

}
