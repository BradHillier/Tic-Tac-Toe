//
//  ticetactoeModel.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-16.
//

import Foundation


/**
 a model of game of tictactoe
 
 - bug: ai will currently still take a move even if the move the player selected was already taken
 - todo: check for a winner after a move, only checking the paths off of the move; have a flag on TicTacToe for the winner maybe a Player?
 */
struct TicTacToe: ConnectionBoardGame {

    typealias Content = Player?
    typealias CommandData = (cell: Board.Cell, player: Player)
    
    var currentPlayer: Player
    var defaultPlayer: Player = .X
    var moves: Array<Command<TicTacToe, CommandData>>
    var undoneMoves: Array<Command<TicTacToe, CommandData>>
    var winner: Player?
    var board: Board
    var connectionsToWin: Int
    var lastMove: Board.Cell?
    
    enum Player: CaseIterable, Hashable {
        case X, O
    }
    
    init(size: Int, condition: Int = 3) {
        board = TicTacToe.emptyGameBoard(size: size)
        connectionsToWin = condition
        currentPlayer = defaultPlayer
        moves = Array<Command<Self, CommandData>>()
        undoneMoves = Array<Command<Self, CommandData>>()
    }
    
    var availableMoves: Set<Board.Cell> { Set(board.cells.filter { $0.content == nil }) }
    
    func choose(cell: Board.Cell) -> Command<Self, CommandData>? {
        if cell.isEmpty() && !isWon() {
            return Command(data: (cell, currentPlayer)) {
                    $0.board.changeContent(of: cell, to: currentPlayer)
            }
        }
        return nil
    }
    
    func isWon() -> Bool {
        if let last = moves.last {
            return board.groups(containing: last.data.cell)!.contains { winningPath(in: $0) }
        }
        return false
    }
    
    func isTerminal() -> Bool {
        return winner != nil || board.isFull()
    }
    
    func nextPlayer() -> Player {
        switch currentPlayer {
        case .X: return .O
        case .O: return .X
        }
    }
}



