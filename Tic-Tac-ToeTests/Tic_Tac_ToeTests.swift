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
        XCTAssertEqual(TicTacToe<Int>.emptyGameBoard().asLinearArrangement.map() { $0.id }.elementsEqual(0..<9), true)
    }
    
    func testPlayerExclamationPrefixOverload() throws {
        XCTAssertEqual(!TicTacToe<Int>.Player.X, TicTacToe<Int>.Player.Y)
        XCTAssertEqual(!TicTacToe<Int>.Player.Y, TicTacToe<Int>.Player.X)
    }

}
