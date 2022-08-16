//
//  Grid.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//

import Foundation

struct Grid<Content> {
    
    
    // An array of the grids cell s
    private(set) var cells: Array<Cell>
    
    // The numbers of cells in each grid row and column
    private let size: Int
    
    struct Cell: Identifiable {
        /* only grid should need to see the id and content*/
        private(set) var id: Int
        private(set) var row: Int
        private(set) var column: Int
        
        var content: Content?
        
        func isEmpty() -> Bool {
            return content == nil
        }
    }
    
    /**
     - Todo: add ability to supply default content for cells
     */
    init(size: Int) {
        self.size = size
        cells = Array<Cell>()
        for number in 0..<size * size {
            cells.append(
                Cell(id: number,
                     row: number % size,
                     column: Int(number / size)
                    ))
        }
    }
    
    /// returns true if all cells in the grid contain `Content`; otherwise false
    func isFull() -> Bool {
        return cells.allSatisfy { $0.content != nil }
    }

    /// returns true if no cells in the grid contain `Content`; otherwise false
    func isEmpty() -> Bool {
        return cells.allSatisfy { $0.content == nil }
    }
    
    /// Returns a an array representation of the grids rows
    func rows() -> [[Cell]] {
        
        /// a 2D array where nested arrays contain the cells for a given row on the `TicTacToe` board
        var rows = [[Cell]]()
        
        /// the first id in the current row
        var start: Int
        
        /// the id of first element in the next row
        var end: Int
        
        for row in 0..<size {
            start = size * row
            end = size * (row + 1)
            rows.append(cells.filter { start <= $0.id && $0.id < end } )
        }
        return rows
    }
    
    ///  Returns the array representations of the grids columns ordered from left to right
    func columns() -> [[Cell]] {
        
        var columns = [[Cell]]()
        
        for column in 0..<size {
            columns.append(cells.filter { ($0.id - column) % size == 0 } )
        }
        return columns
    }
    
    /**
     Returns the grids two corner diagonals represented by an array of `Cell`'s.
     
     Modular arithmetic is utilized to find cells belonging to a diagonal. All cells in a diagonal wil be congruent to
     the diagonals first non-zero ID mod( the size of the grid - 1 )
     for example:
     on a 3x3 grid the cell id's will be as follows
     
            ------------- 
            | 0 | 1 | 2 |
            -------------
            | 3 | 4 | 5 |
            -------------
            | 6 | 7 | 8 |
            -------------
     
     Here, `2` is the first non-zero id for the top right to bottom left diagonal, which is equivalent to `size` - 1.
     every other id in the diagonal (4, 6) are all congruent to 2 mod(3).
     or more generically every id in the diagonal is congruent to.
        `size` - 1 mod( size )
     on the
     in the case of the first and last cells in the grid
     the first cell will always have an id of 0 and the last cell will always be congruent
     */
    func diagonals() -> [[Cell]] {
        
        /// First non-zero id in the top left to bottom right diagonal.
        let secondRowSecondColumnID = size + 1
        
        /// First non-zero id in the bottom left to top right diagonal.
        let topRightID = size - 1
        
        let diagonalTopLeftToBottomRight = cells.filter({ cell in
            cell.id % secondRowSecondColumnID == 0
        })
        let diagonalBottomLeftToTopRight = cells.filter({ cell in
            cell.id != 0 &&
            cell.id % topRightID == 0 &&
            cell.id <= topRightID * size
        })
        return [diagonalTopLeftToBottomRight, diagonalBottomLeftToTopRight]
    }
    
    /**
     Change the the content of the provided cell to the provided content value
     
     - Parameters:
            - cell: The `Cell` whose content will be changed
            - content: The new content for the provided `Cell`
     
     - Returns:
     The modified `Cell` if successful; otherwise `nil`
      
     - Note:
     This function utilizes the fact that a `Cell`'s index in the `cells` array is the same as the `Cell`'s id
     */
    mutating func changeContent(of cell: Cell, to content: Content?) -> Cell? {
        if let chosenIndex = cells.firstIndex(where: { $0.id == cell.id }) {
            cells[chosenIndex].content = content
            return cells[chosenIndex]
        }
        return nil
    }
}
