//
//  Grid.swift
//  Tic-Tac-ToeTests
//
//  Created by Brad Hillier on 2022-08-26.
//

import XCTest
@testable import Tic_Tac_Toe
final class GridTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testGetAdjacentCells() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.adjacent(to: grid.cells[4]),
                       [
                        grid.cells[1], grid.cells[7],                   // middle column
                        grid.cells[0], grid.cells[3], grid.cells[6],    // left column
                        grid.cells[2], grid.cells[5],grid.cells[8]      // right column
                       ]
        )
    }
        
    func testGetAdjacentCellsTopLeftCorner() throws {
        let grid = Grid<Int>(size: 10)
        XCTAssertEqual(grid.adjacent(to: grid.cells[0]), [grid.cells[10], grid.cells[1], grid.cells[11]]
       )
    }
    
    func testColumnContainingFromTopCell() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.column(containing: grid.cells[0]),
           [grid.cells[0], grid.cells[3], grid.cells[6]]
       )
    }
    
    func testColumnContainingFromMiddleCell() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.column(containing: grid.cells[3]),
           [grid.cells[0], grid.cells[3], grid.cells[6]]
       )
    }
    
    func testColumnContainingFromBottomCell() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.column(containing: grid.cells[6]),
           [grid.cells[0], grid.cells[3], grid.cells[6]]
       )
    }
    
    /**
     Tests for Grid.column(containing cell: Cell) -> [Cell]
     */
    func testRowContainingFromLeftCell() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.row(containing: grid.cells[3]),
           [grid.cells[3], grid.cells[4], grid.cells[5]]
       )
    }
    
    func testRowContainingFromMiddleCell() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.row(containing: grid.cells[4]),
           [grid.cells[3], grid.cells[4], grid.cells[5]]
       )
    }
    
    func testRowContainingFromRightCell() throws {
        let grid = Grid<Int>(size: 3)
        XCTAssertEqual(grid.row(containing: grid.cells[5]),
           [grid.cells[3], grid.cells[4], grid.cells[5]]
       )
    }

}
