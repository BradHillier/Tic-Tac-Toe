//
//  Grid.swift
//  Tic-Tac-Toe
//
//  Created by Brad Hillier on 2022-07-17.
//

import Foundation

/// - Bug: potential for bugs caused by assuming a  `Cell`'s id is equivalent to it's positions in the cells array
struct Grid<Content> where Content: Hashable {
    
    
    /// Cells stored by their id property in increasing order; a `Cell`'s id should be equivalent to it's index
    private(set) var cells: Array<Cell>
    
    // The numbers of cells in each grid row and column
    let size: Int
    
    struct Cell: Identifiable, Equatable, Hashable {
        
        /* only grid should need to see the id and content*/
        let id: Int
        let row: Int
        let column: Int
        
        var content: Content?
        
        func isEmpty() -> Bool {
            return content == nil
        }
        static func ==(lhs: Grid<Content>.Cell, rhs: Grid<Content>.Cell) -> Bool {
            return lhs.id == rhs.id
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
                     row: Int(number / size),
                     column: number % size
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
    
    
    /**
    Returns a an array representation of the grids rows
     
    a 2D array where nested arrays contain the cells for a given row on the `TicTacToe` board
    */
    func rows() -> [[Cell]] {
        return Array(0..<size).map { row(containing: cells[$0 * size]) }
    }
    
    ///  Returns the array representations of the grids columns ordered from left to right
    func columns() -> [[Cell]] {
        return Array(0..<size).map { column(containing: cells[$0]) }
    }
    
    /**
     Returns the grids two corner diagonals represented by an array of `Cell`'s.
     
     - Bug: This currently creates two of both diagonals containing the top corners
     */
    func diagonals() -> Set<[Cell]> {
        var diagonals = Set<[Cell]>()
        if let first = columns().first, let last = columns().last {
            for cell in Set(first + last) {
                diagonals.insert(diagonal(containing: cell, slope: .positive))
                diagonals.insert(diagonal(containing: cell, slope: .negative))
            }
        }
        return diagonals
    }
    
    
    /// - Note: tested
    func column(containing cell: Cell) -> [Cell] {
        return Array(0..<size).map { cells[cell.column + size * $0] }
    }
    
    func row(containing cell: Cell) -> [Cell] {
        return Array(0..<size).map { cells[$0 + cell.row * size] }
        
    }
    
    /**
     Returns all cells in the diagonal sloping downward to the right which contains the provided cell
     
     - Parameters:
        - cell: the cell which is contained in the diagonal to be constructed
        - slope:
     
     - Note: This method relies heavily on the fact that a `Cell`'s index in `cells` is equivalent to it's `id`
    */
    func diagonal(containing cell: Cell, slope: Slope ) -> [Cell] {
        
        /// distance between the `id`'s of cells belonging to the diagonals
        let delta: Int
        
        /// maximum possible index of a `Cell` within the constructed diagonal array
        ///  - Todo: rename this
        let maxIndex: Int
        
        /// distance from `cell` to either the top left cell (origin) if `slope.positive` or
        /// top right cell if `slope.negative` stepping diagonally, vertically or horizonatally
        let distanceToTopCorner: Int
        
        /// index of `cell` in the constructed diagonal array if it is sorted by id from lowest to highest
        let indexInDiagonal: Int
        
        let numCellsAfterProvided: Int
        
        /// index of the cell with the lowest id in the diagonal
        let firstIndex: Int
        
        /// index in `cells` with the highest id in the diagonal being created
        let lastIndex: Int
        
        maxIndex = size - 1
        switch slope {
        case .positive:
            distanceToTopCorner = cell.column
            delta = size + 1
        case .negative:
            distanceToTopCorner = maxIndex - cell.column
            delta = size - 1
        }
        indexInDiagonal = min(distanceToTopCorner, cell.row)
        numCellsAfterProvided = maxIndex - max(distanceToTopCorner, cell.row)
        
        firstIndex = cell.id - indexInDiagonal * delta
        lastIndex = cell.id + numCellsAfterProvided * delta
        let count = (lastIndex - firstIndex) / delta
        return Array(0...count).map { cells[firstIndex + $0 * delta] }
    }
    
    func groups(containing cell: Cell?) -> [[Cell]]? {
        if let cell {
            return [
                row(containing: cell),
                column(containing: cell),
                diagonal(containing: cell, slope: .positive),
                diagonal(containing: cell, slope: .negative)
            ]
        }
        return nil
    }
    
    func adjacent(to cell: Cell) -> Array<Cell> {
        let leftIndices = [-size - 1, -1, size - 1]
        let rightIndices = [-size + 1, 1, size + 1]
        
        var adjacentIndices = [-size, size]
        if cell.column != 0 {   // then there must be cells to the left of `cell`
            adjacentIndices += leftIndices
        }
        if cell.column != size - 1 {    // then there must be cells to the right of `cell`
            adjacentIndices += rightIndices
        }
        return adjacentIndices.compactMap {
            let index = cell.id + $0
            if (0..<cells.count).contains(index) {
                return cells[index]
            }
            return nil
        }
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
    @discardableResult
    mutating func changeContent(of cell: Cell, to content: Content?) -> Cell? {
        if let chosenIndex = cells.firstIndex(where: { $0.id == cell.id }) {
            cells[chosenIndex].content = content
            return cells[chosenIndex]
        }
        return nil
    }
    
    func changingContent(of cell: Cell, to content: Content?) -> Self {
        var copy = self
        if let chosenIndex = copy.cells.firstIndex(where: { $0.id == cell.id }) {
            copy.cells[chosenIndex].content = content
        }
        return copy
    }
    
    enum Slope {
        case negative, positive
    }
}
