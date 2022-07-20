//
//  TicTacToeBot.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-20.
//

import Foundation

struct TicTacToeBot {
    // find the move that will result in the lowest possible score
    func min(state: Grid<TicTacToe.Player?>) -> Grid<TicTacToe.Player?>.Cell {
        return state.asLinearArrangement[0]
    }
    
    // find the move that will result in the highest possible score
    func max(state: Grid<TicTacToe.Player?>) -> Grid<TicTacToe.Player?>.Cell {
        return state.asLinearArrangement[0]
    }
}
