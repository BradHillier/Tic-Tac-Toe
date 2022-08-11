//
//  Tic_Tac_ToeTests.swift
//  Tic-Tac-ToeTests
//
//  Created by Brad Hillier on 2022-07-17.
//

import XCTest
@testable import Tic_Tac_Toe

class GameboardManipulationTests: XCTestCase {

    override func setUpWithError() throws {
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testCreateEmptyGameBoard() throws {
        XCTAssertEqual(TicTacToe.emptyGameBoard(size: 3).cells.map() { $0.id }.elementsEqual(0..<9), true)
    }
    
    func testPlayerExclamationPrefixOverload() throws {
        XCTAssertEqual(!TicTacToe.Player.X, TicTacToe.Player.O)
        XCTAssertEqual(!TicTacToe.Player.O, TicTacToe.Player.X)
    }

}
