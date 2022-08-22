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
    
    func testDiagonlsLeft() throws {
        var grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[4], slope: .upward), [grid.cells[2], grid.cells[4], grid.cells[6]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[2], slope: .upward), [grid.cells[2], grid.cells[4], grid.cells[6]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[6], slope: .upward), [grid.cells[2], grid.cells[4], grid.cells[6]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[0], slope: .upward), [grid.cells[2], grid.cells[4], grid.cells[6]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[8], slope: .upward), [grid.cells[8]])
        
        grid = Grid<Int>(size: 4)
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[7], slope: .upward), [grid.cells[7], grid.cells[10], grid.cells[13]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[10], slope: .upward), [grid.cells[7], grid.cells[10], grid.cells[13]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[13], slope: .upward), [grid.cells[7], grid.cells[10], grid.cells[13]])
        
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[11], slope: .upward), [grid.cells[11], grid.cells[14]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[14], slope: .upward), [grid.cells[11], grid.cells[14]])
        
        grid = Grid<Int>(size: 6)
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[28], slope: .upward), [grid.cells[23], grid.cells[28], grid.cells[33]])
    }
    
    func testDiagonlsRightGridSizeThree() throws {
        let grid = Grid<Int>(size: 3)
        
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[0], slope: .downward), [grid.cells[0], grid.cells[4], grid.cells[8]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[4], slope: .downward), [grid.cells[0], grid.cells[4], grid.cells[8]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[8], slope: .downward), [grid.cells[0], grid.cells[4], grid.cells[8]])
    }
    
    func testDiagonlsRightGridSizeFour() throws {
        let grid = Grid<Int>(size: 4)
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[0], slope: .downward), [grid.cells[0], grid.cells[5], grid.cells[10], grid.cells[15]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[5], slope: .downward), [grid.cells[0], grid.cells[5], grid.cells[10], grid.cells[15]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[10], slope: .downward), [grid.cells[0], grid.cells[5], grid.cells[10], grid.cells[15]])
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[15], slope: .downward), [grid.cells[0], grid.cells[5], grid.cells[10], grid.cells[15]])
        
        
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[13], slope: .downward), [grid.cells[8], grid.cells[13]])
        
        XCTAssertEqual(grid.getDiagonal(of: grid.cells[6], slope: .downward), [grid.cells[1], grid.cells[6], grid.cells[11]])
    }
}
