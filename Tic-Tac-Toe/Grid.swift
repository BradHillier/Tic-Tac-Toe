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
    private let size: Int
    
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
    
    func adjacent(to cell: Cell) -> Set<Cell> {
        var adjacentCells = Set<Cell>()
        
        var deltas = [-size, size]
        if cell.id % size != 0 {
            deltas += [-size - 1, -1, size - 1]
        }
        if cell.id % size != size - 1 {
            deltas += [-size + 1, 1, size + 1]
        }
        
        deltas.forEach {
            let index = cell.id + $0
            if 0 <= index && index < cells.count {
                adjacentCells.insert(cells[index])
            }
        }
        return adjacentCells
    }
    
    func groups(containing cell: Cell) -> [[Cell]] {
        let row = getRow(of: cell)
        let col = getColumn(of: cell)
        let pos = getDiagonal(of: cell, slope: .positive)
        let neg = getDiagonal(of: cell, slope: .negative)
        return [row, col, pos, neg]
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
            rows.append(getRow(of: cells[row * size]))
        }
        return rows
    }
    
    func getRow(of cell: Cell) -> [Cell] {
        var row = Array<Cell>()
        let startIndex = cell.row * size
        var index = startIndex
        while index < startIndex + size {
            row.append(cells[index])
            index += 1
        }
        return row
    }
    
    ///  Returns the array representations of the grids columns ordered from left to right
    func columns() -> [[Cell]] {
        
        var columns = [[Cell]]()
        
        for index in 0..<size {
            columns.append(getColumn(of: cells[index]))
        }
        return columns
    }
    
    func getColumn(of cell: Cell) -> [Cell] {
        var column = Array<Cell>()
        var index = cell.column
        while index < cells.count {
            column.append(cells[index])
            index += size
        }
        return column
    }
    
    /**
     Returns the grids two corner diagonals represented by an array of `Cell`'s.
     
     - Bug: This currently creates two of both diagonals containing the top corners
     */
    func diagonals() -> [[Cell]] {
        var diagonals = [Array<Cell>]()
        
        if let firstColumn = columns().first {
            for cell in firstColumn {
                diagonals.append(getDiagonal(of: cell, slope: .positive))
                diagonals.append(getDiagonal(of: cell, slope: .negative))
            }
        }
        
        if let lastColumn = columns().last {
            for cell in lastColumn {
                diagonals.append(getDiagonal(of: cell, slope: .positive))
                diagonals.append(getDiagonal(of: cell, slope: .negative))
            }
        }
        return diagonals
    }
    
    enum Slope {
        case negative, positive
    }

    /**
     Returns all cells in the diagonal sloping downward to the right which contains the provided cell
     
     - Parameters:
        - cell: the cell which is contained in the diagonal to be constructed
        - slope: 
     
     - Note: This method relies heavily on the fact that a `Cell`'s index in `cells` is equivalent to it's `id`
    */
    func getDiagonal(of cell: Cell, slope: Slope ) -> [Cell] {
        
        /// distance between the `id`'s of cells belonging to the diagonals
        let delta: Int
        
        /// maximum possible index of a `Cell` within the constructed diagonal array
        let maxIndex: Int
        
        /// distance from `cell` to either the top left cell (origin) if `slope.positive` or
        /// top right cell if `slope.negative` stepping diagonally, vertically or horizonatally
        let distanceToTopCorner: Int
        
        /// index of `cell` in the constructed diagonal array if it is sorted by id from lowest to highest
        let indexInDiagonal: Int
        
        /// the number of cells appearing downward and to the right of `cell`
        let numCellsAfterProvided: Int
        
        /// index of the cell with the lowest id in the diagonal
        let firstIndex: Int
        
        /// index in `cells` with the highest id in the diagonal being created
        let lastIndex: Int
        
        var diagonal = Array<Cell>()
        
        /// index in `cells` of `Cell` currently being added to `rightDiagonal`
        var currentIndex: Int
        
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
        
        currentIndex = firstIndex
        while currentIndex <= lastIndex {
            diagonal.append(cells[currentIndex])
            currentIndex += delta
        }
        return diagonal
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
